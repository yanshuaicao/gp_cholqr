function plot_setting = get_plot_settings(set_num,scale)
if ~exist('scale','var')
    scale = 1;
end
switch set_num
    case 1
        plot_setting.LW = 1.3*scale;
        plot_setting.MS = 10*scale;
        plot_setting.FS = 16*scale;

        plot_setting.names = [{'CholQR-z16'},{'CholQR-OI-z16'},...
                 {'IVM'},{'IVM-e3'},{'CholQR-AA-z128'},{'CholQR-OI-z64'},{'Random'},{'Titsias-16'},{'CholQR-z8'},{'Titsias-512'},{'CSI'},{'CholQR-z64'},{'CholQR-z8-e3'}];

        plot_setting.marker_syles = {'o','x','h','s','d','v','<','p','+','>','v','*','^'};
        plot_setting.marker_syles = plot_setting.marker_syles(1:length(plot_setting.names));
        plot_setting.colors = lines(length(plot_setting.marker_syles));
        
        plot_setting.get_ind = @(name_str) find(strcmp(name_str,plot_setting.names));
        plot_setting.get_color = @(name_str)  plot_setting.colors(plot_setting.get_ind(name_str),:);
        plot_setting.get_marker = @(name_str) plot_setting.marker_syles{plot_setting.get_ind(name_str)};
 
    case 2
        %same color for same method, and use different markers to differentiate
        %variants
        plot_setting.LW = 1.8*scale;
        plot_setting.MS = 12*scale;
        plot_setting.FS = 20*scale;
        
        plot_setting.name_bases = {'CholQR','IVM','Titsias','FITC','CSI','Random'};
        plot_setting.names = [{'CholQR-z16'},{'CholQR-OI-z16'},...
                 {'IVM'},{'IVM-e3'},{'CholQR-AA-z128'},{'CholQR-OI-z64'},{'Random'},{'Titsias-16'},{'CholQR-z8'},{'Titsias-512'},{'CSI'},{'CholQR-z64'},{'CholQR-z8-e3'}];

        plot_setting.marker_syles = {'o','x','h','s','d','v','<','p','+','>','v','*','^'};
        plot_setting.marker_syles = plot_setting.marker_syles(1:length(plot_setting.names));
        plot_setting.line_syles = {'-','--', '--', '--', '--', '--'};
        
        
        plot_setting.colors = lines(length(plot_setting.name_bases));
        
        plot_setting.get_ind = @(name_str) find(strcmp(name_str,plot_setting.names));
        
        plot_setting.get_base_ind = @(name_str) find(arrayfun(@(j) any(strfind(name_str,plot_setting.name_bases{j})),...
                                                            1:length(plot_setting.name_bases)));
                                                        
        plot_setting.get_color = @(name_str)  plot_setting.colors(plot_setting.get_base_ind(name_str),:);
        plot_setting.get_marker = @(name_str) plot_setting.marker_syles{plot_setting.get_ind(name_str)};
        plot_setting.get_line_style = @(name_str) plot_setting.line_syles{plot_setting.get_base_ind(name_str)};
        
        
     case 3
        % For continuous case
        plot_setting.LW = 1.3*scale;
        plot_setting.MS = 12*scale;
        plot_setting.FS = 20*scale;
        
 
        plot_setting.names = [{'CholQR-MLE'},{'CholQR-VAR'},...
                 {'IVM-VAR'},{'IVM-MLE'}, {'SPGP'}];
        
        plot_setting.marker_syles = {'o','x','h','s','d'};
        plot_setting.line_syles = {'-','-', '--', '--', '--'};
        
        
        plot_setting.colors = {'c','b','k','g','r'};
        
        plot_setting.get_ind = @(name_str) find(strcmp(name_str,plot_setting.names));
        plot_setting.get_cm = @(name_str) [plot_setting.colors{plot_setting.get_ind(name_str)} plot_setting.marker_syles{plot_setting.get_ind(name_str)}];   
                      
        plot_setting.get_clm = @(name_str) [plot_setting.get_cm(name_str)  plot_setting.line_syles{plot_setting.get_ind(name_str)}];

    case 4
        % For 1D snelson example
        plot_setting.LW = 1.3*scale;
        plot_setting.MS = 12*scale;
        plot_setting.FS = 20*scale;
        
        
    otherwise
        error('Unsupported')
end
 