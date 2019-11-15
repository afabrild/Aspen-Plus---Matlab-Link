%% Created by Ing. Andrés Felipe Abril. Universidad Nacional de Colombia. Departamento de Ingeniería Química.
    %% Linking
    Aspen = actxserver('Apwn.Document.36.0'); %34.0 ---> V8.8; 35.0 ---> V9.0; and 36.0 ---> V10.0
    [stat,mess]=fileattrib; % get attributes of folder (Necessary to establish the location of the simulation)
    Simulation_Name = 'Reactive_Distillation';% Aspeen Plus Simulation Name
    Aspen.invoke('InitFromArchive2',[mess.Name '\' Simulation_Name '.bkp']);
    Aspen.Visible = 1; % 1 ---> Aspen is Visible; 0 ---> Aspen is open but not visible
    Aspen.SuppressDialogs = 1; % Suppress windows dialogs.
    Aspen.Engine.Run2(1); % Run the simulation
    while Aspen.Engine.IsRunning == 1 % 1 --> If Aspen is running; 0 ---> If Aspen stop.
        pause(0.5);
    end
    
    %% Example of Application
    Reflux_Ratio = [1, 3, 5, 7];
for i = 1:length(Reflux_Ratio)
    Aspen.Tree.FindNode("\Data\Blocks\RC-101\Input\BASIS_RR").Value = Reflux_Ratio(i); % Column Reflux
    Aspen.Reinit; % Reinit simulation
    Aspen.Engine.Run2(1); %Run the simulation. (1) ---> Matlab isnt busy; (0) Matlab is Busy;
    time = 1;
    while Aspen.Engine.IsRunning == 1 % 1 --> If Aspen is running; 0 ---> If Aspen stop.
        pause(0.5);
        time = time+1;
        if time==15 % Control of simulation time.
            Aspen.Engine.Stop;
        end
    end
    Simulation_Convergency = Aspen.Tree.FindNode("\Data\Results Summary\Run-Status\Output\PCESSTAT").Value; % 1 Doesn't Convergence; 0 Converge
        if Simulation_Convergency == 0 && time < 10
            Duty(i) = Aspen.Tree.FindNode("\Data\Blocks\RC-101\Output\REB_UTL_DUTY").Value; %Duty value of reactive column
        else
            Duty(i) = inf; % Its Penalized if simulation doesn't converge;
        
        end
end

%% Plotting
figure()
plot(Reflux_Ratio, Duty, 'ok');
Aspen.Close;
Aspen.Quit;

    