%% Regressione lineare gruppo 
clear
clc

%% Caricamento dati

load('G13.mat')

%% Ispezione del dataset

summary(tG)

%% Stazione

% 564,Erba - via Battisti,279,CO,Erba,45.80857380692296, 9.22177920448843

%% Statistiche descrittive per alcune variabili

% (comprensione/descrizione dei fenomeni)
mean(tG.NOx_tG1)
std(tG.NOx_tG1)
grpstats(tG,'ARPA_AQ_cod_staz_tG1',{'mean','std','min','max'},'DataVars',{'NOx_tG1'})

%% Dati stazione di Erba

data_erba = tG(:,{'NOx_tG1','NO2_tG1','Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1', 'O3_tG1', 'PM10_tG1'});
data_erba.Properties.VariableNames = {'NOx','NO2','Temperatura','Pioggia','Umidita','Ozono', 'PM10'};
grpstats(tG,'ARPA_AQ_cod_staz_tG1',{'mean','std','min','max'},'DataVars',{'NOx_tG1'})

% creo una serie di grafici di dispersione per avere un' idea preliminare
% sulle possibili relazioni tra variabili indpendenti e la variabile
% dipendente NOx
y=data_erba.NOx;

x=data_erba.Temperatura;
scatter(x,y); %%correlazione negativa 
ylabel('NOx');
xlabel('TEMPERATURA');
title('NOx-TEMPERATURA')

x=data_erba.Umidita;
scatter(x,y);%% correlazione scarsa piccola tendenza positiva
ylabel('NOx');
xlabel('UMIDITÀ');
title('NOx-UMIDITÀ')

x=data_erba.NO2;
scatter(x,y);%% correlazione forte positiva
ylabel('NOx');
xlabel('NO2');
title('NOx-NO2')

x=data_erba.PM10;
scatter(x,y);%% correlazione positiva
ylabel('NOx');
xlabel('PM10');
title('NOx-PM10')

%% Modelli lineari regressivi Erba

% Modello iniziale con tutte le possibili covariate
m_erba = fitlm(data_erba,'ResponseVar','NOx','PredictorVars',{'Temperatura','Umidita', 'NO2', 'PM10', 'Pioggia', 'Ozono'}) % Ra2: 0.927
% la covariata 'Ozono' è quella che presenta significatività minore

m_erba = fitlm(data_erba,'ResponseVar','NOx','PredictorVars',{'Temperatura','Umidita', 'NO2', 'PM10','Pioggia'}) % Ra2: 0.928
%la covariata 'Pioggia' presenta una significatività bassa

m_erba = fitlm(data_erba,'ResponseVar','NOx','PredictorVars',{'Temperatura','Umidita', 'NO2', 'PM10'}) % Ra2: 0.928
% tutte le covariate in questo modello sono significative

%% Stazione
% 583,Bergamo - via Meucci,249,BG,Bergamo,45.69103740547214,9.643650579461385

%% Dati stazione di Bergamo

data_bg = tG(:,{'NOx_BG','NO2_BG','Temperatura_BG','Pioggia_cum_BG','Umidita_relativa_BG', 'O3_BG', 'PM10_BG'});
data_bg.Properties.VariableNames = {'NOx','NO2','Temperatura','Pioggia','Umidita','Ozono', 'PM10'};

%% Scatterplot

y=data_bg.NOx;

x=data_bg.Umidita;
scatter(x,y) %% correlazione dubbia debolmente positiva
ylabel('NOx');
xlabel('UMIDITÀ');
title('NOx-UMIDITÀ')

x=data_bg.NO2;
scatter(x,y)%% correlazione positiva forte
ylabel('NOx');
xlabel('NO2');
title('NOx-NO2')

x=data_bg.PM10;
scatter(x,y) %% correlazione positiva 
ylabel('NOx');
xlabel('PM10');
title('NOx-PM10')

%% Modelli lineari regressivi Bergamo

m_bg = fitlm(data_bg,'ResponseVar','NOx','PredictorVars',{'Temperatura','Umidita', 'NO2', 'PM10', 'Pioggia', 'Ozono'})  % Ra: 0.866
% la covariata 'Ozono' è quella che presenta significatività minore

m_bg = fitlm(data_bg,'ResponseVar','NOx','PredictorVars',{'Temperatura','Umidita', 'NO2', 'PM10', 'Pioggia'}) % Ra: 0.866
%la covariata 'Temperatura' presenta una significatività bassa

m_bg = fitlm(data_bg,'ResponseVar','NOx','PredictorVars',{'Umidita', 'NO2', 'PM10','Pioggia'}) % Ra: 0.867
%la covariata 'Pioggia' presenta una significatività bassa

m_bg = fitlm(data_bg,'ResponseVar','NOx','PredictorVars',{'Umidita', 'NO2', 'PM10'}) % Ra: 0.866
% tutte le covariate in questo modello sono significative


anova_bg = anova(m_bg)
anova_erba = anova(m_erba)

%% Correlazioni Temperatura 

bg = fitlm(data_bg,'ResponseVar','Pioggia','PredictorVars',{'Temperatura'})
bg = fitlm(data_bg,'ResponseVar','Ozono','PredictorVars',{'Temperatura'})
bg = fitlm(data_bg,'ResponseVar','Umidita','PredictorVars',{'Temperatura'})
bg = fitlm(data_bg,'ResponseVar','NO2','PredictorVars',{'Temperatura'})
bg = fitlm(data_bg,'ResponseVar','PM10','PredictorVars',{'Temperatura'})

erba = fitlm(data_erba,'ResponseVar','Pioggia','PredictorVars',{'Temperatura'})
erba = fitlm(data_erba,'ResponseVar','Ozono','PredictorVars',{'Temperatura'})
erba = fitlm(data_erba,'ResponseVar','Umidita','PredictorVars',{'Temperatura'})
erba = fitlm(data_erba,'ResponseVar','NO2','PredictorVars',{'Temperatura'})
erba = fitlm(data_erba,'ResponseVar','PM10','PredictorVars',{'Temperatura'})

%% Analisi residui 

% Bergamo 
bg = fitlm(data_bg,'ResponseVar','NOx','PredictorVars',{'Umidita', 'NO2', 'PM10'}) % Ra: 0.866
res_bg = bg.Residuals.Raw;
plot(res_bg)
yline(0,'r','LineWidth',3);
yline(mean(res_bg),'b','LineWidth',2);
title('Andamento residui - Bergamo')
xlabel('Osservazioni')
ylabel('Residuo')

figure
histfit(res_bg)
title('istogramma residui - Bergamo')
xlabel('Valori residui')
ylabel('Conteggio osservazioni')

figure
plotResiduals(bg,'probability');
title('Andattamento dei residui alla normale - Bergamo')
ylabel('Probabilità')
xlabel('Residuo')

%% plotResiduals(bg,'symmetry')

% Erba
erba = fitlm(data_erba,'ResponseVar','NOx','PredictorVars',{'Temperatura','Umidita', 'NO2', 'PM10'}) % Ra2: 0.928
res_erba = erba.Residuals.Raw;

figure
plot(res_erba)
yline(0,'r','LineWidth',3)
yline(mean(res_erba),'b','LineWidth',2)
title('Andamento residui - Erba')
xlabel('Osservazioni')
ylabel('Residui')

figure
histfit(res_erba)
title('istogramma residui - Erba')
xlabel('Valori residui')
ylabel('Conteggio osservazioni')

figure
plotResiduals(erba,'probability')
title('Andattamento dei residui alla normale - Erba')
ylabel('Probabilità')
xlabel('Residui')