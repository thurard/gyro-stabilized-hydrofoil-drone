% =========================================================================
% Script de balayage longitudinal : Recherche du centre de gravité (Tangage)
% =========================================================================
run('init_naca.m');
model = 'Gyro_tanga'; % Mettre le nom exact de votre modèle Simulink
load_system(model);

% Test de 8 positions d'avant en arrière (de -25 cm à -5 cm)
positions_groupe = linspace(-0.25, -0.05, 8); 
figure('Name', 'Recherche d''équilibre - Tangage');
colors = jet(length(positions_groupe));

for i = 1:length(positions_groupe)
    pos_centre = positions_groupe(i);
    
    % Le format correspond à [Avant/Arrière, Gauche/Droite, Hauteur]
    valeur_bloc = sprintf('[%f 0 0.03]', pos_centre);
    
    % Vérifiez que 'R7' est bien le nom de votre bloc de positionnement
    set_param([model '/R7'], 'TranslationCartesianOffset', valeur_bloc);
    
    % MaxStep à 0.01 lisse les courbes pour un rendu professionnel
    simOut = sim(model, 'ReturnWorkspaceOutputs', 'on', 'FastRestart', 'off', 'MaxStep', '0.01');
    t = simOut.tout;
    
    try
        % Récupération du signal de tangage
        angle_tangage = simOut.logsout.get('Ys').Values.Data; 
        hold on; 
        plot(t, angle_tangage, 'Color', colors(i,:), 'LineWidth', 1.5, ...
             'DisplayName', sprintf('Position : %.2f m', pos_centre));
    catch 
        disp('Signal Ys (Tangage) introuvable.');
    end
end

grid on;
legend('Location', 'best');
title('Effet de la position longitudinale sur le Tangage');
xlabel('Temps (s)'); 
ylabel('Angle de Tangage (deg)');
yline(0, 'k-', 'LineWidth', 2, 'DisplayName', '0° (Plat parfait)');