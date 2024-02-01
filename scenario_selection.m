function scenario_selection()

    f = figure('Position',[200 200 300 300]);
    pnl = uipanel('Parent',f,'Position',[.1 .1 .8 .8]);
    btn1 = uicontrol('Parent',pnl,'Style','pushbutton','String','Surrogate - No Noise','Position',[20 175 200 30],'Callback',@btn1_Callback);
    btn2 = uicontrol('Parent',pnl,'Style','pushbutton','String','Surrogate - Noise','Position',[20 125 200 30],'Callback',@btn2_Callback);
    btn3 = uicontrol('Parent',pnl,'Style','pushbutton','String','Modeling - No Noise','Position',[20 75 200 30],'Callback',@btn3_Callback);
    btn4 = uicontrol('Parent',pnl,'Style','pushbutton','String','Modeling - Noise','Position',[20 25 200 30],'Callback',@btn4_Callback);
    function valore = btn1_Callback(~,~)
        assignin('base', 'scen_1', '_l');
        assignin('base', 'scen_2', '_nn');
        close(f);
    end
    function valore = btn2_Callback(~,~)
        assignin('base', 'scen_1', '_l');
        assignin('base', 'scen_2', '_n');
        close(f);
    end
    function valore = btn3_Callback(~,~)
        assignin('base', 'scen_1', '_nl');
        assignin('base', 'scen_2', '_nn');
        close(f);
    end
    function valore = btn4_Callback(~,~)
        assignin('base', 'scen_1', '_nl');
        assignin('base', 'scen_2', '_n');
        close(f);
    end
    waitfor(f);
end