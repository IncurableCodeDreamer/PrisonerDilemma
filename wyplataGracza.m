function [y1, y2] = wyplataGracza(gracz1,gracz2)

switch gracz1
    case 1
        if(gracz2==1)
         y1=3;
         y2=3;
        elseif(gracz2==2)
         y1=0;
         y2=5;
        end
    case 2
        if(gracz2==1)
         y1=5;
         y2=0;
        elseif(gracz2==2)
         y1=1;
         y2=1;
        end
end