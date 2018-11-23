%%
%语音信号采集程序设计
fs=22050;                  %语音信号采集频率为22050
x=audioread('C:\Users\Administrator\Desktop\信号分析资料\signal_Project\Happy birthday.wav');
sound(x,40000); 
y=fft(x,1024);             %对信号做1024点FFT变换
magX=abs(y);%原始信号幅值
angX=angle(y);%原始信号相位
figure(1);
subplot(2,1,1);plot(magX);title('原始信号幅值');
subplot(2,1,2);plot(angX);title('原始信号相位');
f=fs*(0:511)/512;
figure(2);
subplot(2,1,1);plot(x);title('原始语音信号时域波形图');grid on;
subplot(2,1,2);          %绘制原始语音信号的频率响应图 
plot(f,abs(y(1:512)));
title('原始语音信号频谱图');xlabel('Hz');ylabel('fudu');grid on;

%%
%语音信号加噪程序设计
fs=22050;                  %语音信号采集频率为22050
x=audioread('C:\Users\Administrator\Desktop\信号分析资料\signal_Project\Happy birthday.wav');
%加随机噪声并绘制时域波形和FFT频谱图，作对比
L=length(x);
noise=0.04*randn(L,2);
x1=x+noise;
y=fft(x,1024);   %对信号做1024点FFT变换
figure(1);
subplot(2,1,1);plot(x);        %做原始语音信号的时域图形
title('原始语音信号的时域图')
subplot(2,1,2); plot(x1);      %绘制加噪语音信号的时域图形
title('加噪语音信号的时域图'); xlabel('t');ylabel('x1');
figure(2);
y1=fft(x1,1024);           %对加噪信号做1024点FFT变换
f=fs*(0:511)/512;
subplot(2,1,1);plot(f,abs(y(1:512)));
title('原始语音信号频谱图');xlabel('Hz');ylabel('fudu');grid on;
subplot(2,1,2);plot(f,abs(y1(1:512)));        %绘制原始语音信号频率响应图
title('加噪语音信号频谱图');xlabel('Hz');ylabel('fudu');grid on;
%语音信号滤波去噪程序设计
fs=22050;                  %语音信号采集频率为22050
x=audioread('C:\Users\Administrator\Desktop\信号分析资料\signal_Project\Happy birthday.wav');
%加随机噪声
L=length(x);
noise=0.04*randn(L,2);
x1=x+noise; 

%%
%利用kaiser滤波器对语音信号滤波¨
fp=1000;
fm=1200;
rs=100;Fs=8000; %滤波器设计
wp=2*pi*fp/Fs;
ws=2*pi*fm/Fs;
Bt=ws-wp;   %计算过渡带宽度
alph=0.112*(rs-8.7);%计算kaiser窗的控制参数alph
M=ceil((rs-8)/2.285/Bt);%计算kaiser窗所需阶数M
wc=(wp+ws)/2/pi;
hn=fir1(M,wc,kaiser(M+1,alph));%调用kaiser计算低通FIDF的h(n)
figure(1);
freqz(hn);
y=fft(x);
y1=fft(x1);
x2=fftfilt(hn,x1); %利用kaiser滤波器对语音信号滤波绘图
y=fft(x,1024);   %对原始信号做1024点FFT变换
y1=fft(x1,1024);  %对加噪信号做1024点FFT变换
y2=fft(x2,1024);  %对加噪滤波后的信号做1024点FFT变换
figure(1);
freqz(hn);
grid on 
figure(2)                  %画出时域波形
subplot(3,1,1); 
axis([0 7 -1 1]);
plot(x);
title('原始语音信号的时域波形');
subplot(3,1,2);
plot(x1)
title('加噪后语音信号的时域波形');
subplot(3,1,3); 
plot(x2);
title('加噪语音滤波后信号的时域波形');
f=fs*(0:511)/512;
figure(3)                    %画出频谱图
y1=fft(x1,1024); 
subplot(3,1,1); 
plot(f,abs(y(1:512)));%画出原始语音信号频谱图
title('原始语音信号频谱图')
xlabel('Hz');
ylabel('fuzhi');
subplot(3,1,2);
plot(f,abs(y1(1:512)));         %画出加噪后语音信号频谱图
title('加噪后语音信号频谱图')
xlabel('Hz');
ylabel('fuzhi');
subplot(3,1,3);
 plot(f,abs(y2(1:512)));          %画出滤波后的信号频谱图
title('加噪语音滤波后的信号频谱图')
xlabel('Hz');
ylabel('fuzhi');
