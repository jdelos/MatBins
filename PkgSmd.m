classdef PkgSmd
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private )
        size = [0 0 0];
        volm = 0;
        area = 0;
        h=0;
        w=0;
        l=0;
    end
    
    methods
        
        function PK = PkgSmd(sze)
            PK.size  = sze;
            PK.volm  = prod(sze);
            PK.area  = prod(sze([1 2]));
            PK.h     = sze(3);
            PK.w     = sze(2);
            PK.l     = sze(1);
        end
        
            
        
    end
    
    
    
end

