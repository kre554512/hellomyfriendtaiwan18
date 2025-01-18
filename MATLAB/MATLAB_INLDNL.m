%A=vin_ramp';
%B=out_digi_ramp;
%DNL=zeros(2^N-1,1);
%INL=zeros(2^N,1);
bit=10;
b=size(B);
LSB=1.8/2^bit;
i=2;
for j=1:1:2^bit-1
    DNL(j)=(B(i,1)-B(i-1,1))/LSB;                  
    INL(j+1)=(B(i,1)-A(i,1))/LSB;
    %DNL(j)=INL(i)-INL(i-1);
    i=i+1;
end
INL(1)=(B(1,1)-A(1,1))/LSB;

INLx=INL+0.5;


figure(1)
subplot(2,1,1);
plot(-INL);
grid on;
title('-INL') 
xlabel('Digital Code')
ylabel('INL/LSB')
subplot(2,1,2);
plot(-DNL);
grid on;
title('-DNL') 
xlabel('Digital Code')
ylabel('DNL/LSB')


%subplot(3,1,3);
%plot(-INLx);
%grid on;
%title('-INLx') 
%xlabel('Digital Code')
%ylabel('INL/LSB')


%DNL=zeros(1024,1);  Âk¹s
%INL=0;
%sf=0;
%ct=0;
%A=0;
%B=0;
