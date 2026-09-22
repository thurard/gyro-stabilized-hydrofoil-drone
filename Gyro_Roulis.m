% =========================================================================
% Script d'étude du Roulis : Impact de la position longitudinale
% =========================================================================
run('init_naca.m');
model = 'Gyro_roulis'; 
load_system(model);

% Remplacer par le nom exact du bloc lié au gyroscope dans ce modèle
nom_du_bloc = [model '/R10']; 

% Sécurité : Forcer le bloc à utiliser les coordonnées cartésiennes
set_param(nom_du_bloc, 'TranslationMethod', 'Cartesian');

% Test de 8 positions d'avant en arrière (de -15 cm à +15 cm sur la longueur)
positions_groupe = linspace(-0.15, 0.15, 8); 
figure('Name', 'Recherche d''équilibre - Roulis');
colors = jet(length(positions_groupe));

for i = 1:length(positions_groupe)
    pos_centre = positions_groupe(i);
    
    % Le %f est bien en PREMIÈRE position (Axe longitudinal d'avant en arrière)
    valeur_bloc = sprintf('[%f 0 0.03]', pos_centre);
    
    set_param(nom_du_bloc, 'TranslationCartesianOffset', valeur_bloc);
    
    % Lancement de la simulation (MaxStep 0.01 pour lisser les courbes)
    simOut = sim(model, 'ReturnWorkspaceOutputs', 'on', 'FastRestart', 'off', 'MaxStep', '0.01');
    t = simOut.tout;
    
    try
        % Récupération du signal de roulis
        angle_roulis = simOut.logsout.get('XS').Values.Data; 
        hold on; 
        plot(t, angle_roulis, 'Color', colors(i,:), 'LineWidth', 1.5, ...
             'DisplayName', sprintf('Position : %.2f m', pos_centre));
    catch 
        disp('Signal XS (Roulis) introuvable.');
    end
end

grid on;
legend('Location', 'best');
title('Effet de la position longitudinale sur le Roulis');
xlabel('Temps (s)'); 
ylabel('Angle d''inclinaison (deg)');
yline(0, 'k-', 'LineWidth', 2, 'DisplayName', '0° (Plat parfait)');