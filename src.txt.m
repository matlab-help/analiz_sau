classdef tau < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        SAU_ANALIZ20UIFigure  matlab.ui.Figure
        UIAxes                matlab.ui.control.UIAxes
        Button                matlab.ui.control.Button
        ButtonGroup           matlab.ui.container.ButtonGroup
        Button_2              matlab.ui.control.RadioButton
        Button_3              matlab.ui.control.RadioButton
        Button_4              matlab.ui.control.RadioButton
        Button_5              matlab.ui.control.RadioButton
        Button_6              matlab.ui.control.RadioButton
        Button_7              matlab.ui.control.RadioButton
        ReWjwButton           matlab.ui.control.RadioButton
        ImWjwButton           matlab.ui.control.RadioButton
        Button_10             matlab.ui.control.RadioButton
        Button_11             matlab.ui.control.RadioButton
        Button_12             matlab.ui.control.RadioButton
        Label                 matlab.ui.control.Label
        EditField             matlab.ui.control.EditField
        Label_2               matlab.ui.control.Label
        EditField_2           matlab.ui.control.EditField
        Button_9              matlab.ui.control.Button
        Label_3               matlab.ui.control.Label
        EditField_3           matlab.ui.control.EditField
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: Button
        function ButtonPushed(app, event)
            ax = app.UIAxes;
            B = eval(app.EditField.Value)
            disp(B)
            A = eval(app.EditField_2.Value)
            disp(A)
            W = tf(B,A);
            if app.Button_4.Value == 1
                clear a b
                [s t] = step(W)
                plot(ax,t,s)
                title(ax,'Переходный процесс')
                xlabel(ax,'t')
                ylabel(ax,'h')
            end
            if app.Button_2.Value == 1
                clear a b
                [a b w] = bode(W);
                plot(ax,w(:),a(:))
                title(ax,'АЧХ')
                xlabel(ax,'w')
                ylabel(ax,'A')
            end
            if app.Button_3.Value == 1
                clear a b
                [a b] = nyquist(W);
                plot(ax,a(:),b(:))
                title(ax,'АФЧХ')
                xlabel(ax,'+1')
                ylabel(ax,'j')
            end
            if app.Button_5.Value == 1
                clear a b
                [a b] = impulse(W);
                plot(ax,a(:),b(:))
                title(ax,'Импульсная характеристика')
                xlabel(ax,'t')
                ylabel(ax,'h')
            end
            if app.Button_6.Value == 1
                clear a b
                a = pole(W)
                plot(ax,real(a(:)),imag(a(:)),'r*','LineWidth' ,2)
                title(ax,'Карта полюсов')
                xlabel(ax,'Re')
                ylabel(ax,'Im')
            end
            if app.Button_7.Value == 1
                clear a b
                [a b w] = bode(W);
                plot(ax,w(:),b(:))
                title(ax,'ФЧХ')
                xlabel(ax,'w')
                ylabel(ax,'fi')
            end
            if app.ReWjwButton.Value == 1
                clear a b
                w0 = eval(app.EditField_3.Value)
                A = eval(app.EditField.Value)
                B = eval(app.EditField_2.Value)
                p = tf([1 0],1);
                w = (0:0.01:w0)*i;
                pol_A = 0;
                pol_B = 0;
                for j = 1:length(A)
                    pol_A = pol_A + A(j)*w.^(length(A)-j);
                end
                for j = 1:length(B)
                    pol_B = pol_B + B(j)*w.^(length(B)-j);
                end
                U = real(pol_A./pol_B);
                plot(ax,imag(w),U)
                title(ax,'Re(W(jw))')
                xlabel(ax,'w')
                ylabel(ax,'Re(W(jw))')
            end
            if app.ImWjwButton.Value == 1
                clear a b
                w0 = eval(app.EditField_3.Value)
                A = eval(app.EditField.Value)
                B = eval(app.EditField_2.Value)
                p = tf([1 0],1);
                w = (0:0.01:w0)*i;
                pol_A = 0;
                pol_B = 0;
                for j = 1:length(A)
                    pol_A = pol_A + A(j)*w.^(length(A)-j);
                end
                for j = 1:length(B)
                    pol_B = pol_B + B(j)*w.^(length(B)-j);
                end
                V = imag(pol_A./pol_B);
                plot(ax,imag(w),V)
                title(ax,'Im(W(jw))')
                xlabel(ax,'w')
                ylabel(ax,'Im(W(jw))')
            end
            if app.Button_10.Value == 1
                clear a b
                [a b w] = bode(W);
                plot(ax,log10(w(:)),20*log10(a(:)))
                title(ax,'ЛАЧХ')
                xlabel(ax,'lg(w)')
                ylabel(ax,'20lg(A)')
            end
            if app.Button_11.Value == 1
                clear a b
                [a b w] = bode(W);
                plot(ax,log10(w(:)),(b(:)))
                title(ax,'ЛФЧХ')
                xlabel(ax,'lg(w)')
                ylabel(ax,'fi(A)')
            end
            if app.Button_12.Value == 1
                clear a b
                w0 = eval(app.EditField_3.Value)
                B = eval(app.EditField_2.Value)
                p = tf([1 0],1);
                w = (0:0.01:w0)*i;
                pol_B = 0;
                for j = 1:length(B)
                    pol_B = pol_B + B(j)*w.^(length(B)-j);
                end
                U = real(pol_B);
                V = imag(pol_B);
                plot(ax,U,V)
                title(ax,'Годограф Михайлова')
                xlabel(ax,'Im(D)')
                ylabel(ax,'Re(D)')
            end
            grid(ax,'on')
            
        end

        % Button pushed function: Button_9
        function Button_9Pushed(app, event)
            %% сохранение таблицы
            PathName = uigetdir('0','Куда сохранить таблицу');
            Filaname = strcat('\таблица_',strrep(string(datetime),':','-'),'.xlsx');
            %% точки переходного процесса
            B = eval(app.EditField.Value);
            A = eval(app.EditField_2.Value);
            W = tf(B,A);
            [s t] = step(W);
            xlswrite(strcat(PathName,Filaname),[string('время'), string('значение функции'),string('время (загрубление)'), string('значение функции (загрубление)')],'Переходная функция','A1:D1');
            xlswrite(strcat(PathName,Filaname),[t s],'Переходная функция',strcat('A2:B',string(length(s))));
            k = 1;
            t1 = [];
            s1 = [];
            for j = 1:5:length(s)
                t1(k)  = t(j);
                s1(k)  = s(j);
                k = k+1;
            end
            xlswrite(strcat(PathName,Filaname),[t1' s1'],'Переходная функция',strcat('C2:D',string(length(s1))));
            clear s t s1 t1 j k
            %% точки импульсной характеристики
            B = eval(app.EditField.Value);
            A = eval(app.EditField_2.Value);
            W = tf(B,A);
            [s t] = impulse(W);
            xlswrite(strcat(PathName,Filaname),[string('время'), string('значение функции'),string('время (загрубление)'), string('значение функции (загрубление)')],'Импульсная функция','A1:D1');
            xlswrite(strcat(PathName,Filaname),[t s],'Импульсная функция',strcat('A2:B',string(length(s))));
            k = 1;
            t1 = [];
            s1 = [];
            for j = 1:5:length(s)
                t1(k)  = t(j);
                s1(k)  = s(j);
                k = k+1;
            end
            xlswrite(strcat(PathName,Filaname),[t1' s1'],'Импульсная функция',strcat('C2:D',string(length(s1))));
            %% точки годографа найквиста
            A = eval(app.EditField.Value)
            B = eval(app.EditField_2.Value)
            w0 = eval(app.EditField_3.Value);
            p = tf([1 0],1);
            w = (0:0.01:w0)*i;
            pol_A = 0;
            pol_B = 0;
            for j = 1:length(A)
                pol_A = pol_A + A(j)*w.^(length(A)-j);
            end
            for j = 1:length(B)
                pol_B = pol_B + B(j)*w.^(length(B)-j);
            end
            U = real(pol_A./pol_B);
            V = imag(pol_A./pol_B);
            xlswrite(strcat(PathName,Filaname),[string('частота'), string('Re(W(j*w))'), string('Im(W(j*w))'), string('частота (загрубление)'), string('Re(W(j*w)) (загрубление)'), string('Im(W(j*w)) (загрубление)')],'Годограф Найквиста','A1:F1');
            xlswrite(strcat(PathName,Filaname),[imag(w)' U' V'],'Годограф Найквиста',strcat('A2:C',string(length(w))));
            k = 1;
            w1 = [];
            V1 = [];
            U1 = [];
            for j = 1:5:length(w)
                w1(k)  = w(j);
                V1(k)  = V(j);
                U1(k)  = U(j);
                k = k+1;
            end
            xlswrite(strcat(PathName,Filaname),[imag(w1)' U1' V1'],'Годограф Найквиста',strcat('D2:F',string(length(w1))));
            clear w V U w1 V1 U1
            %% точки АЧХ и ФЧХ
            A = eval(app.EditField.Value)
            B = eval(app.EditField_2.Value)
            w0 = eval(app.EditField_3.Value)
            p = tf([1 0],1);
            w = (0:0.01:w0)*i;
            pol_A = 0;
            pol_B = 0;
            for j = 1:length(A)
                pol_A = pol_A + A(j)*w.^(length(A)-j);
            end
            for j = 1:length(B)
                pol_B = pol_B + B(j)*w.^(length(B)-j);
            end
            U = real(pol_A./pol_B);
            V = imag(pol_A./pol_B);
            AMP = sqrt(U.^2+V.^2);
            fi  = atan(V./U)
            xlswrite(strcat(PathName,Filaname),[string('частота'), string('амплитуда'), string('фаза'), string('частота (загрубление)'), string('амплитуда (загрубление)'), string('фаза (загрубление)')],'АЧХ и ФЧХ','A1:F1');
            xlswrite(strcat(PathName,Filaname),[imag(w)' AMP' fi'],'АЧХ и ФЧХ',strcat('A2:C',string(length(w))));
            k = 1;
            w1 = [];
            AMP1 = [];
            fi1 = [];
            for j = 1:5:length(w)
                w1(k)  = w(j);
                AMP1(k)  = AMP(j);
                fi1(k)  = fi(j);
                k = k+1;
            end
            xlswrite(strcat(PathName,Filaname),[imag(w1)' AMP1' fi1'],'АЧХ и ФЧХ',strcat('D2:F',string(length(w1))));
            clear w V U w1 V1 U1
            %% точки ЛАЧХ и ЛФЧХ
            A = eval(app.EditField.Value)
            B = eval(app.EditField_2.Value)
            w0 = eval(app.EditField_3.Value)
            p = tf([1 0],1);
            w = (0:0.5:w0)*i;
            pol_A = 0;
            pol_B = 0;
            for j = 1:length(A)
                pol_A = pol_A + A(j)*w.^(length(A)-j);
            end
            for j = 1:length(B)
                pol_B = pol_B + B(j)*w.^(length(B)-j);
            end
            U = real(pol_A./pol_B);
            V = imag(pol_A./pol_B);
            AMP = 20*log10(sqrt(U.^2+V.^2));
            fi  = atan(V./U)
            xlswrite(strcat(PathName,Filaname),[string('логарифм частоты'), string('логарифм амплитуды'), string('фаза'), string('логарифм частоты (загрубление)'), string('логарифм амплитуды (загрубление)'), string('фаза (загрубление)')],'АЧХ и ФЧХ','A1:F1');
            xlswrite(strcat(PathName,Filaname),[log10(imag(w))' AMP' fi'],'ЛАЧХ и ЛФЧХ',strcat('A2:C',string(length(w))));
            k = 1;
            w1 = [];
            AMP1 = [];
            fi1 = [];
            for j = 1:5:length(w)
                w1(k)  = w(j);
                AMP1(k)  = AMP(j);
                fi1(k)  = fi(j);
                k = k+1;
            end
            xlswrite(strcat(PathName,Filaname),[log10(imag(w1))' AMP1' fi1'],'ЛАЧХ и ЛФЧХ',strcat('D2:F',string(length(w1))));
            clear w V U w1 V1 U1
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create SAU_ANALIZ20UIFigure and hide until all components are created
            app.SAU_ANALIZ20UIFigure = uifigure('Visible', 'off');
            app.SAU_ANALIZ20UIFigure.Position = [100 100 1010 600];
            app.SAU_ANALIZ20UIFigure.Name = 'SAU_ANALIZ 2.0';

            % Create UIAxes
            app.UIAxes = uiaxes(app.SAU_ANALIZ20UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.PlotBoxAspectRatio = [1.89020771513353 1 1];
            app.UIAxes.Position = [313 17 678 489];

            % Create Button
            app.Button = uibutton(app.SAU_ANALIZ20UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.FontSize = 14;
            app.Button.FontWeight = 'bold';
            app.Button.Position = [29 217 230 24];
            app.Button.Text = 'Построить';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.SAU_ANALIZ20UIFigure);
            app.ButtonGroup.Title = 'Характеристика';
            app.ButtonGroup.FontWeight = 'bold';
            app.ButtonGroup.Position = [29 309 230 273];

            % Create Button_2
            app.Button_2 = uiradiobutton(app.ButtonGroup);
            app.Button_2.Text = 'АЧХ';
            app.Button_2.FontWeight = 'bold';
            app.Button_2.Position = [11 227 58 22];
            app.Button_2.Value = true;

            % Create Button_3
            app.Button_3 = uiradiobutton(app.ButtonGroup);
            app.Button_3.Text = 'Годограф Найквиста';
            app.Button_3.FontWeight = 'bold';
            app.Button_3.Position = [11 167 146 22];

            % Create Button_4
            app.Button_4 = uiradiobutton(app.ButtonGroup);
            app.Button_4.Text = 'Переходный процесс';
            app.Button_4.FontWeight = 'bold';
            app.Button_4.Position = [11 110 150 22];

            % Create Button_5
            app.Button_5 = uiradiobutton(app.ButtonGroup);
            app.Button_5.Text = 'Импульсную характеристику';
            app.Button_5.FontWeight = 'bold';
            app.Button_5.Position = [11 84 197 22];

            % Create Button_6
            app.Button_6 = uiradiobutton(app.ButtonGroup);
            app.Button_6.Text = 'Карта полюсов';
            app.Button_6.FontWeight = 'bold';
            app.Button_6.Position = [11 59 113 22];

            % Create Button_7
            app.Button_7 = uiradiobutton(app.ButtonGroup);
            app.Button_7.Text = 'ФЧХ';
            app.Button_7.FontWeight = 'bold';
            app.Button_7.Position = [75 227 49 22];

            % Create ReWjwButton
            app.ReWjwButton = uiradiobutton(app.ButtonGroup);
            app.ReWjwButton.Text = 'Re(W(jw))';
            app.ReWjwButton.FontWeight = 'bold';
            app.ReWjwButton.Position = [11 33 77 22];

            % Create ImWjwButton
            app.ImWjwButton = uiradiobutton(app.ButtonGroup);
            app.ImWjwButton.Text = 'Im(W(jw))';
            app.ImWjwButton.FontWeight = 'bold';
            app.ImWjwButton.Position = [11 9 76 22];

            % Create Button_10
            app.Button_10 = uiradiobutton(app.ButtonGroup);
            app.Button_10.Text = 'ЛАЧХ';
            app.Button_10.FontWeight = 'bold';
            app.Button_10.Position = [11 196 58 22];

            % Create Button_11
            app.Button_11 = uiradiobutton(app.ButtonGroup);
            app.Button_11.Text = 'ЛФЧХ';
            app.Button_11.FontWeight = 'bold';
            app.Button_11.Position = [75 196 57 22];

            % Create Button_12
            app.Button_12 = uiradiobutton(app.ButtonGroup);
            app.Button_12.Text = 'Годограф Михайлова';
            app.Button_12.FontWeight = 'bold';
            app.Button_12.Position = [11 137 150 22];

            % Create Label
            app.Label = uilabel(app.SAU_ANALIZ20UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontSize = 16;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [314 547 92 22];
            app.Label.Text = 'Числитель';

            % Create EditField
            app.EditField = uieditfield(app.SAU_ANALIZ20UIFigure, 'text');
            app.EditField.FontSize = 16;
            app.EditField.FontWeight = 'bold';
            app.EditField.Position = [419 547 220 23];
            app.EditField.Value = '[1]';

            % Create Label_2
            app.Label_2 = uilabel(app.SAU_ANALIZ20UIFigure);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.FontSize = 16;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [313 512 110 22];
            app.Label_2.Text = 'Знаменатель';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.SAU_ANALIZ20UIFigure, 'text');
            app.EditField_2.FontSize = 16;
            app.EditField_2.FontWeight = 'bold';
            app.EditField_2.Position = [438 511 247 23];
            app.EditField_2.Value = '[1 1]';

            % Create Button_9
            app.Button_9 = uibutton(app.SAU_ANALIZ20UIFigure, 'push');
            app.Button_9.ButtonPushedFcn = createCallbackFcn(app, @Button_9Pushed, true);
            app.Button_9.FontSize = 14;
            app.Button_9.FontWeight = 'bold';
            app.Button_9.Position = [29 178 230 24];
            app.Button_9.Text = 'Сохранить таблицу значений';

            % Create Label_3
            app.Label_3 = uilabel(app.SAU_ANALIZ20UIFigure);
            app.Label_3.HorizontalAlignment = 'right';
            app.Label_3.FontSize = 16;
            app.Label_3.FontWeight = 'bold';
            app.Label_3.Position = [30 279 167 22];
            app.Label_3.Text = 'частота для расчета';

            % Create EditField_3
            app.EditField_3 = uieditfield(app.SAU_ANALIZ20UIFigure, 'text');
            app.EditField_3.FontSize = 16;
            app.EditField_3.FontWeight = 'bold';
            app.EditField_3.Position = [30 253 105 23];
            app.EditField_3.Value = '500';

            % Show the figure after all components are created
            app.SAU_ANALIZ20UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = tau

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.SAU_ANALIZ20UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.SAU_ANALIZ20UIFigure)
        end
    end
end