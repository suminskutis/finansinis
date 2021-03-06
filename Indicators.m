%%Stochastic oscillator
%K = (Current Close - Lowest Low)/(Highest High - Lowest Low) * 100
%D = 3-day SMA of %K
%Lowest Low = lowest low for the look-back period
%Highest High = highest high for the look-back period

datas = readData('EURUSD_0701_0930.csv');
highestHighs = 1:66;
lowestLows   = 1:66;
currentClose = datas.close(14:end); % kokiu periodu atgal ziuresime = 14
stochasticOscillator = 1:52;
simpleMovingAverage = 1:52;

%find lows and highs for look-back period
for i = 1:52
    highestHighs(i) = max(datas.high(0+i:13+i));
    lowestLows(i) = min(datas.low(0+i:13+i));
end
%calculate stochastic oscillator 
for i = 1:52
    stochasticOscillator(i) = (currentClose(i) - lowestLows(i))/(highestHighs(i) - lowestLows(i)) * 100;
end
% three day SMA of SO
for i = 1:50
    simpleMovingAverage(i+2) = ( stochasticOscillator(i) + stochasticOscillator(i+1) + stochasticOscillator(i+2) )/3;
end
simpleMovingAverage(1:2) = NaN;

figure(1) 
h = plot(datas.date(14:end-1), stochasticOscillator,  datas.date(14:end-1), simpleMovingAverage, 'r');grid on;
set(h(1),'linewidth',2);
set(h(2),'linewidth',1);
datetick('x', 'dd-mm', 'keepticks');
title('Stochastic Oscillator - EURUSD July-September 2016');
legend('Stochastic Oscillator', 'SMA')
%% Accumulation distribution line // Cumulative Money Flow Line
 % 1. Money Flow Multiplier = [(Close  -  Low) - (High - Close)] /(High - Low) 
 % 2. Money Flow Volume = Money Flow Multiplier x Volume for the Period
 % 3. ADL = Previous ADL + Current Period's Money Flow Volume
 
 datas = readData('EURUSD1440.csv');
 
 %calculate money flow multiplier, money flow value and ADL for 1 month
 for i = 1:24
     MFM(i) = ((datas.close(i) - datas.low(i)) - (datas.high(i) - datas.close(i))) / (datas.high(i) - datas.low(i));
 end
 
 for i = 1:24
     MFV(i) = MFM(i) * datas.volume(i);
 end
 
 % first value of ADL is the current value of MFV
 ADL(1) = MFV(1);
 
 for i = 2:24
     ADL(i) = ADL(i-1) + MFV(i);
 end
 
 plot(datas.date(1:24),ADL)
 datetick('x', 'dd-mm', 'keepticks'); grid on;
 title('Accumulation distribution line - EURUSD August 2016');
 legend('Accumulation distribution line')
 %%
 %Envelopes
 %Upper Envelope: 20-day SMA + (20-day SMA x .025)
 %Lower Envelope: 20-day SMA - (20-day SMA x .025)
 
 datas = readData('EURUSD_0701_0930.csv');
 
 for i = 1:46
     SMA(i) = mean(datas.close(1+i:20+i)); 
 end
 
 for i = 1:46
     UpperEnvelope(i) = SMA(i) + (SMA(i) * 0.025);
     LowerEnvelope(i) = SMA(i) - (SMA(i) * 0.025);
 end
 
 figure(3)
 h = plot(datas.date(21:66), SMA, datas.date(21:66), UpperEnvelope, datas.date(21:66), LowerEnvelope)
 set(h(1),'linewidth',2);
 set(h(2),'linewidth',1);
 set(h(3),'linewidth',1);
 datetick('x', 'dd-mm', 'keepticks'); grid on;
 title('Moving average envelopes- EURUSD August-September 2016');
 legend('SimpleMovingAverage', 'UpperEnvelope', 'LowerEnvelope')
 

 
 %%
 %Williams percent range // %R
 %R = (Highest High - Close)/(Highest High - Lowest Low) * -100
%Lowest Low = lowest low for the look-back period
%Highest High = highest high for the look-back period
%R is multiplied by -100 correct the inversion and move the decimal.

datas = readData('EURUSD_0701_0930.csv');
highestHighs = 1:66;
lowestLows   = 1:66;
currentClose = datas.close(14:end); % kokiu periodu atgal ziuresime = 14
WilliamsR = 1:52;

for i = 1:52
    highestHighs(i) = max(datas.high(0+i:13+i));
    lowestLows(i) = min(datas.low(0+i:13+i));
end

for i = 1:52
    WilliamsR(i) = (highestHighs(i) - currentClose(i))/(highestHighs(i) - lowestLows(i)) * -100;
end
figure(4)
plot(datas.date(14:end-1), WilliamsR, 'LineWidth', 1);grid on;
datetick('x', 'dd-mm', 'keepticks');
title('WilliamsR - EURUSD July-September 2016');
legend('WilliamsR')

%% Chaikin Oscillator
 % Chaikin Oscillator = (3-day EMA of ADL)  -  (10-day EMA of ADL)	

%SMA: 10 period sum / 10                                               
%Multiplier: (2 / (Time periods + 1) ) = (2 / (10 + 1) ) = 0.1818 (18.18%)
%EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
 
 datas = readData('EURUSD1440.csv');
 SMA3 = mean(ADL(1:3));
 SMA10 = mean (ADL(1:10));
 threeDayMultiplier = ( 2/(3+1) );
 tenDaysMultiplier = (2/(10+1)) ;
 threeDayEMA = 1:31;
 threeDayEMA(1) = threeDayMultiplier * (datas.close(3) - SMA3) + SMA3 ;
 tenDayEMA = 1:31;
 tenDayEMA(1) = tenDaysMultiplier * (datas.close(10) - SMA10) + SMA10;
 
 for i = 2:31
     threeDayEMA(i) = threeDayMultiplier * (datas.close(i+2) - threeDayEMA(i-1)) + threeDayEMA(i-1) ;
 end
 
 for i = 2:31
     tenDayEMA(i) = tenDaysMultiplier * (datas.close(i+9) - tenDayEMA(i-1)) + tenDayEMA(i-1);
 end
 
 for i = 1:24
     CO(i) = threeDayEMA(i+7) - tenDayEMA(i);
 end
 
 plot(CO)
 
  
 
 