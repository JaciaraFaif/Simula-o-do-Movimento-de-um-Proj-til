classdef ProjectileMotionSimulatorAppCode_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        GHTanswer                    matlab.ui.control.Label
        SYManswer                    matlab.ui.control.Label
        basedonverticaldisplacementyLabel  matlab.ui.control.Label
        SymbolicVerticalVelocityytattime1sLabel  matlab.ui.control.Label
        GroundHitTimeLabel           matlab.ui.control.Label
        STIMULATEButton              matlab.ui.control.Button
        Maxheightanswer              matlab.ui.control.Label
        HRanswer                     matlab.ui.control.Label
        HorizontalRangeLabel         matlab.ui.control.Label
        MaxHeightLabel               matlab.ui.control.Label
        PROJECTILEMOTIONSIMULATORENG316PROJECTLabel  matlab.ui.control.Label
        ProjectileTypeDropDown       matlab.ui.control.DropDown
        ProjectileTypeDropDownLabel  matlab.ui.control.Label
        InputsPanel                  matlab.ui.container.Panel
        GravitationalAccelaration98ms2Label  matlab.ui.control.Label
        InitialHeightEditField       matlab.ui.control.NumericEditField
        InitialHeightEditFieldLabel  matlab.ui.control.Label
        AngleEditField               matlab.ui.control.NumericEditField
        AngleLabel                   matlab.ui.control.Label
        InitialVelocityEditField     matlab.ui.control.NumericEditField
        InitialVelocityLabel         matlab.ui.control.Label
        graph2                       matlab.ui.control.UIAxes
        graph3                       matlab.ui.control.UIAxes
        graph1                       matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: STIMULATEButton
        function stimulatebutton(app, event)

            v0 = app.InitialVelocityEditField.Value;
            angle = app.AngleEditField.Value;
            Initial_height=app.InitialHeightEditField.Value;
            g =9.81;

            [x,y,v,t]=ProjectileTrajectory(v0,angle,Initial_height,g);
            xlswrite('Projectile_Motion_Data',[t', x', y', v'], 'Sheet 1', 'A1:D150');

            for i = 2:length(y)
                if y(i) <= 0
                    ground_hit_time =t(i);
                    app.GHTanswer.Text = sprintf('%.2f s', ground_hit_time);
                    break;
                end
            end

            [MaxHeight, Horizontal_Range]=HeightAndRange(v0, angle, Initial_height, g, x);
            if MaxHeight < 20
                app.Maxheightanswer.Text = sprintf('Projectile reached low altitude of %.2f m', MaxHeight);
            elseif MaxHeight < 50
                app.Maxheightanswer.Text = sprintf('Projectile reached medium altitude of %.2f m', MaxHeight);
            else
                app.Maxheightanswer.Text = sprintf('Projectile reached high altitude of %.2f m', MaxHeight);
            end

            app.HRanswer.Text = sprintf('%.2f m', Horizontal_Range)
            syms T
            y_sym = Initial_height + v0 * sind(angle) * T - 0.5 * g * T^2;
            vy_sym = diff(y_sym);
            time = 1;
            Vy_result = double(subs(vy_sym, T, time));
            app.SYManswer.Text = sprintf('%.2f m/s', Vy_result);

            PlotGraph(app, x, y, v, t, Initial_height, v0, angle, g)

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.8 0.8 0.8];
            app.UIFigure.Position = [100 100 1109 609];
            app.UIFigure.Name = 'MATLAB App';

            % Create graph1
            app.graph1 = uiaxes(app.UIFigure);
            title(app.graph1, 'Title')
            xlabel(app.graph1, 'X')
            ylabel(app.graph1, 'Y')
            zlabel(app.graph1, 'Z')
            app.graph1.Position = [303 293 364 250];

            % Create graph3
            app.graph3 = uiaxes(app.UIFigure);
            title(app.graph3, 'Title')
            xlabel(app.graph3, 'X')
            ylabel(app.graph3, 'Y')
            zlabel(app.graph3, 'Z')
            app.graph3.Position = [438 33 474 242];

            % Create graph2
            app.graph2 = uiaxes(app.UIFigure);
            title(app.graph2, 'Title')
            xlabel(app.graph2, 'X')
            ylabel(app.graph2, 'Y')
            zlabel(app.graph2, 'Z')
            app.graph2.Position = [697 295 401 248];

            % Create InputsPanel
            app.InputsPanel = uipanel(app.UIFigure);
            app.InputsPanel.Title = 'Inputs';
            app.InputsPanel.Position = [19 402 240 151];

            % Create InitialVelocityLabel
            app.InitialVelocityLabel = uilabel(app.InputsPanel);
            app.InitialVelocityLabel.HorizontalAlignment = 'right';
            app.InitialVelocityLabel.Position = [-2 100 81 22];
            app.InitialVelocityLabel.Text = 'Initial Velocity:';

            % Create InitialVelocityEditField
            app.InitialVelocityEditField = uieditfield(app.InputsPanel, 'numeric');
            app.InitialVelocityEditField.HorizontalAlignment = 'left';
            app.InitialVelocityEditField.Position = [93 100 100 22];

            % Create AngleLabel
            app.AngleLabel = uilabel(app.InputsPanel);
            app.AngleLabel.Position = [7 69 46 22];
            app.AngleLabel.Text = 'Angle:';

            % Create AngleEditField
            app.AngleEditField = uieditfield(app.InputsPanel, 'numeric');
            app.AngleEditField.HorizontalAlignment = 'left';
            app.AngleEditField.Position = [90 69 103 22];

            % Create InitialHeightEditFieldLabel
            app.InitialHeightEditFieldLabel = uilabel(app.InputsPanel);
            app.InitialHeightEditFieldLabel.Position = [7 39 74 22];
            app.InitialHeightEditFieldLabel.Text = 'Initial Height:';

            % Create InitialHeightEditField
            app.InitialHeightEditField = uieditfield(app.InputsPanel, 'numeric');
            app.InitialHeightEditField.HorizontalAlignment = 'left';
            app.InitialHeightEditField.Position = [90 39 103 22];

            % Create GravitationalAccelaration98ms2Label
            app.GravitationalAccelaration98ms2Label = uilabel(app.InputsPanel);
            app.GravitationalAccelaration98ms2Label.HorizontalAlignment = 'center';
            app.GravitationalAccelaration98ms2Label.FontSize = 10;
            app.GravitationalAccelaration98ms2Label.FontAngle = 'italic';
            app.GravitationalAccelaration98ms2Label.FontColor = [1 0 0];
            app.GravitationalAccelaration98ms2Label.Position = [7 18 208 22];
            app.GravitationalAccelaration98ms2Label.Text = 'Gravitational Accelaration = 9.8m/s^2';

            % Create ProjectileTypeDropDownLabel
            app.ProjectileTypeDropDownLabel = uilabel(app.UIFigure);
            app.ProjectileTypeDropDownLabel.HorizontalAlignment = 'right';
            app.ProjectileTypeDropDownLabel.FontSize = 14;
            app.ProjectileTypeDropDownLabel.Position = [13 360 97 22];
            app.ProjectileTypeDropDownLabel.Text = 'Projectile Type';

            % Create ProjectileTypeDropDown
            app.ProjectileTypeDropDown = uidropdown(app.UIFigure);
            app.ProjectileTypeDropDown.Items = {'-select-', 'Rock', 'Ball'};
            app.ProjectileTypeDropDown.FontSize = 14;
            app.ProjectileTypeDropDown.Position = [131 360 100 22];
            app.ProjectileTypeDropDown.Value = '-select-';

            % Create PROJECTILEMOTIONSIMULATORENG316PROJECTLabel
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel = uilabel(app.UIFigure);
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.BackgroundColor = [0.6353 0.0784 0.1843];
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.HorizontalAlignment = 'center';
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.FontName = 'Arial Rounded MT Bold';
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.FontSize = 18;
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.FontWeight = 'bold';
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.Position = [183 565 729 23];
            app.PROJECTILEMOTIONSIMULATORENG316PROJECTLabel.Text = 'PROJECTILE MOTION SIMULATOR- ENG316 PROJECT';

            % Create MaxHeightLabel
            app.MaxHeightLabel = uilabel(app.UIFigure);
            app.MaxHeightLabel.FontSize = 14;
            app.MaxHeightLabel.Position = [17 295 85 16];
            app.MaxHeightLabel.Text = 'Max Height:';

            % Create HorizontalRangeLabel
            app.HorizontalRangeLabel = uilabel(app.UIFigure);
            app.HorizontalRangeLabel.FontSize = 14;
            app.HorizontalRangeLabel.Position = [19 328 131 22];
            app.HorizontalRangeLabel.Text = 'Horizontal Range:';

            % Create HRanswer
            app.HRanswer = uilabel(app.UIFigure);
            app.HRanswer.FontSize = 14;
            app.HRanswer.Position = [141 329 224 22];
            app.HRanswer.Text = '';

            % Create Maxheightanswer
            app.Maxheightanswer = uilabel(app.UIFigure);
            app.Maxheightanswer.WordWrap = 'on';
            app.Maxheightanswer.FontSize = 14;
            app.Maxheightanswer.Position = [101 274 250 43];
            app.Maxheightanswer.Text = '';

            % Create STIMULATEButton
            app.STIMULATEButton = uibutton(app.UIFigure, 'push');
            app.STIMULATEButton.ButtonPushedFcn = createCallbackFcn(app, @stimulatebutton, true);
            app.STIMULATEButton.Position = [73 51 158 54];
            app.STIMULATEButton.Text = 'STIMULATE';

            % Create GroundHitTimeLabel
            app.GroundHitTimeLabel = uilabel(app.UIFigure);
            app.GroundHitTimeLabel.FontSize = 14;
            app.GroundHitTimeLabel.Position = [17 245 111 22];
            app.GroundHitTimeLabel.Text = 'Ground Hit Time:';

            % Create SymbolicVerticalVelocityytattime1sLabel
            app.SymbolicVerticalVelocityytattime1sLabel = uilabel(app.UIFigure);
            app.SymbolicVerticalVelocityytattime1sLabel.FontSize = 14;
            app.SymbolicVerticalVelocityytattime1sLabel.Position = [13 209 324 25];
            app.SymbolicVerticalVelocityytattime1sLabel.Text = 'Symbolic Vertical Velocity y''(t) at time 1s ';

            % Create basedonverticaldisplacementyLabel
            app.basedonverticaldisplacementyLabel = uilabel(app.UIFigure);
            app.basedonverticaldisplacementyLabel.FontSize = 14;
            app.basedonverticaldisplacementyLabel.Position = [13 185 276 25];
            app.basedonverticaldisplacementyLabel.Text = 'based on vertical displacement y():';

            % Create SYManswer
            app.SYManswer = uilabel(app.UIFigure);
            app.SYManswer.FontSize = 14;
            app.SYManswer.Position = [241 186 79 22];
            app.SYManswer.Text = '';

            % Create GHTanswer
            app.GHTanswer = uilabel(app.UIFigure);
            app.GHTanswer.FontSize = 14;
            app.GHTanswer.Position = [131 245 225 22];
            app.GHTanswer.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ProjectileMotionSimulatorAppCode_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end