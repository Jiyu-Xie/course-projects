%%
%�����źŲɼ��������
fs=22050;                  %�����źŲɼ�Ƶ��Ϊ22050
x=audioread('C:\Users\Administrator\Desktop\�źŷ�������\signal_Project\Happy birthday.wav');
sound(x,40000); 
y=fft(x,1024);             %���ź���1024��FFT�任
magX=abs(y);%ԭʼ�źŷ�ֵ
angX=angle(y);%ԭʼ�ź���λ
figure(1);
subplot(2,1,1);plot(magX);title('ԭʼ�źŷ�ֵ');
subplot(2,1,2);plot(angX);title('ԭʼ�ź���λ');
f=fs*(0:511)/512;
figure(2);
subplot(2,1,1);plot(x);title('ԭʼ�����ź�ʱ����ͼ');grid on;
subplot(2,1,2);          %����ԭʼ�����źŵ�Ƶ����Ӧͼ 
plot(f,abs(y(1:512)));
title('ԭʼ�����ź�Ƶ��ͼ');xlabel('Hz');ylabel('fudu');grid on;

%%
%�����źż���������
fs=22050;                  %�����źŲɼ�Ƶ��Ϊ22050
x=audioread('C:\Users\Administrator\Desktop\�źŷ�������\signal_Project\Happy birthday.wav');
%���������������ʱ���κ�FFTƵ��ͼ�����Ա�
L=length(x);
noise=0.04*randn(L,2);
x1=x+noise;
y=fft(x,1024);   %���ź���1024��FFT�任
figure(1);
subplot(2,1,1);plot(x);        %��ԭʼ�����źŵ�ʱ��ͼ��
title('ԭʼ�����źŵ�ʱ��ͼ')
subplot(2,1,2); plot(x1);      %���Ƽ��������źŵ�ʱ��ͼ��
title('���������źŵ�ʱ��ͼ'); xlabel('t');ylabel('x1');
figure(2);
y1=fft(x1,1024);           %�Լ����ź���1024��FFT�任
f=fs*(0:511)/512;
subplot(2,1,1);plot(f,abs(y(1:512)));
title('ԭʼ�����ź�Ƶ��ͼ');xlabel('Hz');ylabel('fudu');grid on;
subplot(2,1,2);plot(f,abs(y1(1:512)));        %����ԭʼ�����ź�Ƶ����Ӧͼ
title('���������ź�Ƶ��ͼ');xlabel('Hz');ylabel('fudu');grid on;
%�����ź��˲�ȥ��������
fs=22050;                  %�����źŲɼ�Ƶ��Ϊ22050
x=audioread('C:\Users\Administrator\Desktop\�źŷ�������\signal_Project\Happy birthday.wav');
%���������
L=length(x);
noise=0.04*randn(L,2);
x1=x+noise; 

%%
%����kaiser�˲����������ź��˲���
fp=1000;
fm=1200;
rs=100;Fs=8000; %�˲������
wp=2*pi*fp/Fs;
ws=2*pi*fm/Fs;
Bt=ws-wp;   %������ɴ����
alph=0.112*(rs-8.7);%����kaiser���Ŀ��Ʋ���alph
M=ceil((rs-8)/2.285/Bt);%����kaiser���������M
wc=(wp+ws)/2/pi;
hn=fir1(M,wc,kaiser(M+1,alph));%����kaiser�����ͨFIDF��h(n)
figure(1);
freqz(hn);
y=fft(x);
y1=fft(x1);
x2=fftfilt(hn,x1); %����kaiser�˲����������ź��˲���ͼ
y=fft(x,1024);   %��ԭʼ�ź���1024��FFT�任
y1=fft(x1,1024);  %�Լ����ź���1024��FFT�任
y2=fft(x2,1024);  %�Լ����˲�����ź���1024��FFT�任
figure(1);
freqz(hn);
grid on 
figure(2)                  %����ʱ����
subplot(3,1,1); 
axis([0 7 -1 1]);
plot(x);
title('ԭʼ�����źŵ�ʱ����');
subplot(3,1,2);
plot(x1)
title('����������źŵ�ʱ����');
subplot(3,1,3); 
plot(x2);
title('���������˲����źŵ�ʱ����');
f=fs*(0:511)/512;
figure(3)                    %����Ƶ��ͼ
y1=fft(x1,1024); 
subplot(3,1,1); 
plot(f,abs(y(1:512)));%����ԭʼ�����ź�Ƶ��ͼ
title('ԭʼ�����ź�Ƶ��ͼ')
xlabel('Hz');
ylabel('fuzhi');
subplot(3,1,2);
plot(f,abs(y1(1:512)));         %��������������ź�Ƶ��ͼ
title('����������ź�Ƶ��ͼ')
xlabel('Hz');
ylabel('fuzhi');
subplot(3,1,3);
 plot(f,abs(y2(1:512)));          %�����˲�����ź�Ƶ��ͼ
title('���������˲�����ź�Ƶ��ͼ')
xlabel('Hz');
ylabel('fuzhi');
