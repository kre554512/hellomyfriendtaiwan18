% fs = 25e+6;
fs = 10e3;
T = 1/fs;
L = 10240;
t = (0: L-1) * T;

%%%put your data in yn, only column is  available%%%

yn = ballenob;


f = (fs/L) * (0:L-1);

window_function = hanning(L);

fft_result = fft(yn.*window_function);

data_length = length(fft_result);

power_fft = (fft_result.*conj(fft_result))/((data_length/2)^2) ;

normalized_power_fft = power_fft / max(power_fft(4:data_length/2));


% power_in_dB_fft = 10*log10(normalized_power_fft);

max_power = max(power_fft(4:data_length/2));

donimated_bin = 0;  
for i =4 : 1 : ((data_length)/2)

    if(power_fft(i) == max_power)
    
    donimated_bin = i;   
   end
          
end

total_power = 0;
for i = 4 : 1 : (data_length/2)
   
    total_power = total_power + normalized_power_fft(i);
    
end

noise_power = total_power - normalized_power_fft(donimated_bin-1) - normalized_power_fft(donimated_bin) - normalized_power_fft(donimated_bin+1);
signal_power = total_power - noise_power;

for i = 1 :1 :7
    
    
    if(donimated_bin + i*(donimated_bin-1) < L)
        
        if(donimated_bin + i*(donimated_bin-1) <(L/2) )
            
            harmonic_f(i) = donimated_bin + i*(donimated_bin-1);
            
        elseif(donimated_bin + i*(donimated_bin-1) > (L/2) )
            harmonic_f(i) = ((L/2)+1) - (donimated_bin + i*(donimated_bin-1) -((L/2)+1));
        end
    else
         if(mod(donimated_bin + i*(donimated_bin-1) , L) <(L/2) )
            
            harmonic_f(i) =mod(donimated_bin + i*(donimated_bin-1) , L);
            
        elseif(mod(donimated_bin + i*(donimated_bin-1) , L) > (L/2) )
            harmonic_f(i) = ((L/2)+1) - (mod(donimated_bin + i*(donimated_bin-1) , L) - ((L/2)+1) );
         end
        
    end
    
end
   harmonic_power = 0;
   for i = 1 : 1 : 7
      for j = -1 : 1 :1
          harmonic_power = harmonic_power + normalized_power_fft(harmonic_f(i) + j );
      end
   end
   sndr = 10*log10(signal_power / (noise_power));
   snr = 10*log10((harmonic_power+signal_power)/(noise_power-harmonic_power));
   thd = 10*log10(harmonic_power/normalized_power_fft(donimated_bin));
   enob = (sndr-1.76)/6.02;
   sfdr = 10*log10(signal_power / (normalized_power_fft(harmonic_f(1)) +  normalized_power_fft(harmonic_f(1) + 1)  +normalized_power_fft(harmonic_f(1) - 1) ) ) ;
plot(1,1)
title('power spectrum density of FFT(dB)');
plot(f(1:L/2) , 1.25*power_in_dB_fft(1:L/2) ,'b' ,'LineWidth',2);
hold on
set(gca,'FontSize',20);
yticks(-100:10:0);
xlabel('frequency(f)')
ylabel('Normalized Power in B Per Hz');
% text(fs/4 , -20 , sprintf('SNDR : %2.6f dB' ,sndr), 'FontSize',20)
% text(fs/4 , -40 , sprintf('SNR  : %2.6f dB' ,snr), 'FontSize',20)
% text(fs/4 , -60 , sprintf('THD  : %2.6f dB' ,thd), 'FontSize',20)
% text(fs/4 , -80 , sprintf('SFDR : %2.6f dB' ,sfdr), 'FontSize',20)
% text(fs/4 , -100 , sprintf('ENOB : %2.6f dB' ,enob), 'FontSize',20)
hold on

% for i=1 :1 :7
%     plot(f(harmonic_f(i)) , power_in_dB_fft(harmonic_f(i) ) , 'r*')
%     text( f(harmonic_f(i)), power_in_dB_fft(harmonic_f(i) ) , num2str(i+1) ,'FontSize',24);
% end
hold on
% plot( f(donimated_bin) , power_in_dB_fft(donimated_bin), 'black');
% text(f(donimated_bin),power_in_dB_fft(donimated_bin),'input tone' ,'FontSize',24,'Color','black');

grid;
grid on;