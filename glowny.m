clc; clear all; close all;
%mozliwosci dla gracza:
%1 wspol
%2 zdrada

%mozliwosci
mozliwosci = [1 2 3 4];
      
%mapa kolorow
colory = [ 0 0 1   
           0 1 0
           1 1 0
           1 0 0];
   
%dane
iloscIteracji = 20;
liczbaGraczy = 100; %parzysta!!
%liczbaMaxGraczyDoRozrodu = 4; -> mozna tez okreslic
wartoscMinFuncjiPrzystosowania = 0.1;
pktWyboruKrzyzowanie = 5; %bit
stopienMutacji = 3; %ile genow zmutuje
liczbaTur = 70;
zaplataZdrada = 5;
zaplataWspolpraca = 3;
zaplataPodwojnaZdrada = 1;

%macierz zaplat
macierzZaplat = zeros(2,2);
macierzZaplat(1,1) = zaplataWspolpraca;
macierzZaplat(2,1) = zaplataZdrada;
macierzZaplat(2,2) = zaplataPodwojnaZdrada;

for h=1:iloscIteracji

    if(h~=1)
        macierzGraczy = nowaPopulacja;
    end
%ranomowe obieranie pierwszych n odpowiedzi graczy
%generowanie chromosomow + wyplat graczy
    if(h==1)
        for i=1:liczbaGraczy
            macierzGraczy(i,:)=randi(2,1,liczbaTur);
            if(i~=1)
                for a=1:liczbaTur
                    [wyplataG1, wyplataG2] = wyplataGracza(macierzGraczy(i-1,a),macierzGraczy(i,a));
                    macierzWyplatGraczy(i-1,a) = wyplataG1;
                    macierzWyplatGraczy(i,a) = wyplataG2;
                end
            end
        end
        
    elseif(h~=1)
        macierzWyplatGraczy=[];
        for i=1:size(macierzGraczy,1)
             if(i~=1)
                for a=1:liczbaTur
                    [wyplataG1, wyplataG2] = wyplataGracza(macierzGraczy(i-1,a),macierzGraczy(i,a));
                    macierzWyplatGraczy(i-1,a) = wyplataG1;
                    macierzWyplatGraczy(i,a) = wyplataG2;
                end
            end
        end
    end
    
%obliczanie odchylenia std, jesli: 
%std=srednia -> 1 partner
%std=2*std + srednia -> 2 partnerow
%std= srednia - std -> 0 partnerow
    sredniaGlobalna = mean(mean(macierzWyplatGraczy,2)) %sr wszystkich graczy
    odchylenie = std(macierzWyplatGraczy,1,2); %std dla kazdnego gracza
    srednie = mean(macierzWyplatGraczy,2);

  %wykresy
%     figure;    
%     subplot(3,1,1)
%     histfit(macierzWyplatGraczy(:));
%     title(['Histogram wyplat w iteracji ->', num2str(h)]);
%     subplot(3,1,2)
%     histfit(odchylenie);
%     title(['Histogram odchylenia std wyplat w iteracji ->', num2str(h)]);
%     subplot(3,1,3)
%     histfit(macierzGraczy(:));
%     title(['Histogram decyzji graczy w iteracji ->', num2str(h)]);
%     
%     figure;
%     x = (1:1:size(macierzWyplatGraczy,1));
%     y = mean(macierzWyplatGraczy,2);
%     e = std(macierzWyplatGraczy,1,2);
%     errorbar(x,y',e,'rx');
%     set(gca,'xtick',1:1:size(macierzWyplatGraczy,1));
%     title(['Bledy odchylenia std wyplat od sredniej w iteracji ->', num2str(h)]);

%generowanie populacji do rozrodu + jej ewolucja
    nowaPopulacja1=[];
    nowaPopulacja2=[];
    
    for i=1:size(macierzGraczy,1)
        %macierzOdchylen(i)=std(macierzWyplatGraczy(i))
        %if(macierzOdchylen(i,1)==0)
         if(srednie(i,1)-round(sredniaGlobalna) == 0)
            kolejnoscLosowa = randperm(size(macierzGraczy,1));
            gracze = kolejnoscLosowa(1:1);
            nowaPopulacja=ewolucja(i,gracze,pktWyboruKrzyzowanie,stopienMutacji,macierzGraczy,liczbaTur);
            nowaPopulacja1=[nowaPopulacja1;nowaPopulacja];
         elseif(srednie(i,1)-sredniaGlobalna >= wartoscMinFuncjiPrzystosowania)
        %elseif(macierzOdchylen(i,1)-sredniaGlobalna>2)
            kolejnoscLosowa = randperm(size(macierzGraczy,1));
            gracze = kolejnoscLosowa(1:2);
            nowaPopulacja=ewolucja(i,gracze,pktWyboruKrzyzowanie,stopienMutacji,macierzGraczy,liczbaTur);
            nowaPopulacja2=[nowaPopulacja2;nowaPopulacja];
         %elseif(srednie(i,1)-srednieGlobalna < wartoscMinFuncjiPrzystosowania)
         %elseif(macierzOdchylen(i,:));
        end
    end
    
    if(isempty(nowaPopulacja1))
    nowaPopulacja = nowaPopulacja2;
    elseif(isempty(nowaPopulacja2))
    nowaPopulacja = nowaPopulacja1;
    elseif((~isempty(nowaPopulacja1)) && (~isempty(nowaPopulacja2)))
    nowaPopulacja = [nowaPopulacja1; nowaPopulacja2];
    
    if(isempty(nowaPopulacja))
        break;
    end
    end
   
    %wykresy
    figure;
    subplot(2,1,1)
    plot(srednie,'r*-');
    title(['Srednie wyplaty graczy w iteracji ->', num2str(h)]); 
    hline = refline([0 sredniaGlobalna]);
    subplot(2,1,2)
    plot(srednie,'k*-');
    title(['Zakwalifikowani gracze do podwojnego rozrodu w iteracji ->', num2str(h)]);
    hline = refline([0 (wartoscMinFuncjiPrzystosowania+sredniaGlobalna)]);
    
    % gra nowa populacja
    macierzDecyzji = [];
    macierzWyplatIteracje = [];
    for b=1:liczbaTur
    [paraDecyzjiGra, macierzDecyzjiGra, macierzWyplatGra] = gra(nowaPopulacja);
    macierzDecyzji = [macierzDecyzji; macierzDecyzjiGra'];
    macierzWyplatIteracje = [macierzWyplatIteracje; macierzWyplatGra'];
    modaGraIter=mode(paraDecyzjiGra);
    macierzMody(h,b) = modaGraIter;
    end

end
modaCalejGry = mode(mode(macierzMody))
