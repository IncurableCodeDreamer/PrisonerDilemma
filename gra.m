function [paraDecyzjiGra, decyzje, macierzWyplatIter]  = gra(nowaPopulacja)
    
    [m,n] = size(nowaPopulacja);
    if(mod(m,2)~= 0)
    nowaPopulacja(end,:) = [];
    end
    
    for i=1:2:(m/2)
         kolejnoscLosowa = randperm(size(nowaPopulacja,1));
         gracze = kolejnoscLosowa(1:2);
         para(1,:)=nowaPopulacja(gracze(1),:);
         para(2,:)=nowaPopulacja(gracze(2),:);
         
         nowaPopulacja(gracze(1),:) = [];
         if(size(nowaPopulacja,1)<gracze(2))
             nowaPopulacja(size(nowaPopulacja,1),:) = [];
         else
             nowaPopulacja(gracze(2),:) = [];
         end
              
%          figure;
%          subplot(2,1,1)
%          hist(para(1,:));
%          title(['Hitogram decyzji graczy ',num2str(i)]);
%          hold on
%          hist(para(2,:));
%          set(gca,'xtick',1:1:2);
%          subplot(2,1,2)
%          [f,xi] = ksdensity(para(1,:));
%          plot(xi,f,'*r');
%          hold on
%          [f,xi] = ksdensity(para(2,:));
%          plot(xi,f,'*b');
%          title(['Prawdopodobienstwo kazdego wyboru dla gracza ',num2str(i)]);

%          figure;
%          subplot(2,1,1)
%          normplot(para(1,:))
%          hold on
%          normplot(para(2,:))
%          set(gca,'xtick',1:1:2);
%          title(['Prawdopodobienstwo dla rozkladu normalnego dla gracza ',num2str(i)]);
%         
%          subplot(2,1,2)
%          cdfplot(para(1,:))
%          hold on
%          cdfplot(para(2,:))
%          title(['Prawdopodobienstwo kazdego wyboru dla gracza ',num2str(i)])
        
%          figure;
%          xaxes = (0:0.1:2);
%          func = evcdf(xaxes,0,length(para(1,:)));
%          plot(xaxes,func,'m');
%          hold on
%          func = evcdf(xaxes,0,length(para(2,:)));
%          plot(xaxes,func,'m');
%          set(gca,'xtick',1:1:2);
%          title(['Prawdopodobienstwo kazdego wyboru dla gracza ',num2str(i)])
%          legend('Empirical','Theoretical')
        
         modaG1 = mode(para(1,:));
         modaG2 = mode(para(2,:));
         prob_yG1 = arrayfun(@(x)length(find(para(1,:)==x)),unique(para(1,:)))/length(para(1,:));
         prob_yG2 = arrayfun(@(x)length(find(para(2,:)==x)),unique(para(2,:)))/length(para(2,:));
         
         ostDecyzjeG1 =[para(2,n-2) para(2,n-1) para(2,n)];
         ostDecyzjeG2 =[para(1,n-2) para(1,n-1) para(1,n)];
         
         nowaDecyzjaG1 = para(2,size(para,1)-1); %tylko ostatnia decyzja
         nowaDecyzjaG2 = para(1,size(para,1)-1);
         %nowaDecyzjaG1 = datasample(ostDecyzjeG2,1); %random z 3 ostatnich
         %decyzji
         %nowaDecyzjaG2 = datasample(ostDecyzjeG1,1);
         
         macierzDecyzji(i,1) =  nowaDecyzjaG1;
         macierzDecyzji(i,2) =  nowaDecyzjaG2;
         
         [wyp1, wyp2] = wyplataGracza(nowaDecyzjaG1,nowaDecyzjaG2);
         macierzWyplatIteracje(i,1) = wyp1;
         macierzWyplatIteracje(i,2) = wyp2;
         
         result = strcat(num2str(nowaDecyzjaG1), num2str(nowaDecyzjaG2));
         result = str2num(result);
         paraDecyzji(i,1) = result;
         
         %macierzWyplatIter(i,:) = macierzWyplatIteracje'
    end
    paraDecyzjiGra = paraDecyzji;
    decyzje = macierzDecyzji;
    macierzWyplatIter= macierzWyplatIteracje;
    
    paraDecyzjiGra( ~any(paraDecyzjiGra,2), : ) = [];  %rows
    decyzje( ~any(decyzje,2), : ) = [];
    macierzWyplatIter( ~any(macierzWyplatIter,2), : ) = [];  %rows
    
end
