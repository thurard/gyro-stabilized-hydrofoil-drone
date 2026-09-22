% =========================================================================
% Initialisation des profils NACA 0012 pour le foil
% =========================================================================
% Ce script génère les matrices de coordonnées 'points' et 'c_points' 
% nécessaires aux blocs Simscape "Aile principale" et "Ailette".

% --- Définition du profil principal ---
c = 0.15; 
t = 0.12; 
x_naca = linspace(0, c, 100)';
yt = 5*t*c*(0.2969*sqrt(x_naca/c) - 0.1260*(x_naca/c) - 0.3516*(x_naca/c).^2 + 0.2843*(x_naca/c).^3 - 0.1015*(x_naca/c).^4);
points = [flipud(x_naca), flipud(yt); x_naca(2:end), -yt(2:end)];

% --- Définition de l'ailette ---
c_aillette = 0.1; 
c_t = 0.08; 
x_ail = linspace(0, c_aillette, 50)';
c_yt = 5*c_t*c_aillette*(0.2969*sqrt(x_ail/c_aillette) - 0.1260*(x_ail/c_aillette) - 0.3516*(x_ail/c_aillette).^2 + 0.2843*(x_ail/c_aillette).^3 - 0.1015*(x_ail/c_aillette).^4);
c_points = [flipud(x_ail), flipud(c_yt); x_ail(2:end), -c_yt(2:end)];

disp('Profils NACA générés et chargés avec succès dans le Workspace.');