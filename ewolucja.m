function y =ewolucja(a,gracze,pktWyboruKrzyzowanie,stopienMutacji,macierzGraczy,liczbaTur)
z=1;
%krzyzowanie graczy
    for i=1:length(gracze)
        czesc1 = macierzGraczy(a,1:pktWyboruKrzyzowanie-1);
        czesc2 = macierzGraczy(gracze(i),1:pktWyboruKrzyzowanie-1);
        czesc3 = macierzGraczy(a,pktWyboruKrzyzowanie:end);
        czesc4 = macierzGraczy(gracze(i),pktWyboruKrzyzowanie:end);
        nowaPopulacjaKrzyzowanie(z,:)=[czesc1 czesc4];
        nowaPopulacjaKrzyzowanie(z+1,:)=[czesc3 czesc2];
        z=z+1;
    end

%mutacja graczy
    for i=1:size(nowaPopulacjaKrzyzowanie,1)
        for b=1:stopienMutacji
        nrMutujacegoGenu = randi(liczbaTur);
        nowyGen = randi(4);
        nowaPopulacjaMutacja(i,:) = nowaPopulacjaKrzyzowanie(i,:);
        nowaPopulacjaMutacja(i,nrMutujacegoGenu) = nowyGen;
        end
    end
    y = nowaPopulacjaMutacja;
end