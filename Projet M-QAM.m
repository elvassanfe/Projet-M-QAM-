function generate_qam_constellation(M, exclude_points)
    % Génère les points de la constellation QAM.
    side_len = sqrt(M);

    % Ajuste la longueur des côtés pour des cas spécifiques
    if M == 32
        side_len_x = 6;
        side_len_y = 6;
    elseif M == 128
        side_len_x = 12;
        side_len_y = 12;
    elseif M == 512
        side_len_x = 24;
        side_len_y = 24;
    elseif M == 2048
        side_len_x = 46;
        side_len_y = 46;
    else
        side_len_x = side_len;
        side_len_y = side_len;
    end

    % Génère tous les points possibles dans la grille avec un espacement de 2 unités
    [x, y] = meshgrid(-side_len_x + 1:2:side_len_x - 1, -side_len_y + 1:2:side_len_y - 1);
    points = [x(:), y(:)];

    % Supprime le point à l'origine (0, 0)
    points = points(~all(points == 0, 2), :);
    
    % Initialiser exclude_points pour stocker les points à exclure
    excluded_points = [];
    if exclude_points > 0
        
        % Calcule l'énergie et la phase de chaque symbole
        energy = sqrt(points(:,1).^2 + points(:,2).^2);
        phase = atan2(points(:,2), points(:,1));
        phase = mod(phase + 2*pi, 2*pi);

        % Trie les points par phase croissante
        [~, sort_indices] = sort(phase);
        points = points(sort_indices, :);

         % Exclure les points du centre pour maintenir la symétrie des quadrants
         excluded_points = points(1:exclude_points, :);
       
        % Supprime les points exclus de la liste de tous les points
        points = setdiff(points, excluded_points, 'rows');
    end

    % Sauvegarde des points dans un fichier MAT
    save('qam_constellation.mat', 'points', 'excluded_points');
end

function gray_codes = generate_gray_code(n)
    % Génère les codes Gray pour un nombre n de bits
    num_codes = 2^n;
    gray_codes = zeros(num_codes, n);
    for i = 0:num_codes-1
        gray_codes(i+1, :) = bitxor(i, bitshift(i, -1));
    end
end

function plot_circle(x_center, y_center, radius, color)
    % Fonction pour dessiner un cercle
    theta = linspace(0, 2*pi, 100); % 100 points pour dessiner le cercle
    x_circle = radius * cos(theta) + x_center;
    y_circle = radius * sin(theta) + y_center;
    plot(x_circle, y_circle, 'Color', color, 'LineStyle', '--'); % Cercle en pointillés
end

function plot_qam_constellation(M, SNR)
    % Crée une MAP pour définir le nombre de points exclus selon la taille M
    exclusions = containers.Map({4, 16, 32, 64, 128}, {0, 0, 4, 16, 16});
    exclude_points = isKey(exclusions, M) * exclusions(M);

    % Charger les points générés
    generate_qam_constellation(M, exclude_points);
    load('qam_constellation.mat', 'points', 'excluded_points');
     
    % Définition des points et des labels Gray correspondant
    if M == 4
        points_q1 = [1 1]; points_q2 = [-1 1]; points_q3 = [-1 -1]; points_q4 = [1 -1];
         gray_labels = [0, 1, 3, 2];
         points = [points_q1; points_q2; points_q3; points_q4];
      elseif M == 16
         points_q1 = [1 1; 1 3; 3 1; 3 3]; points_q2 = [-1 1; -1 3; -3 1; -3 3]; points_q3 = [-1 -1; -1 -3; -3 -1; -3 -3]; points_q4 = [1 -1; 1 -3; 3 -1; 3 -3];
         gray_labels = [0, 1, 3, 2, 4, 5, 7, 6, 12, 13, 15, 14, 8, 9, 11, 10];
           points = [points_q1; points_q2; points_q3; points_q4];
     elseif M == 32
        points_q1 = [1 1; 1 3; 3 1; 3 3; 5 1; 5 3; 1 5; 3 5]; 
         points_q2 = [-1 1; -1 3; -3 1; -3 3; -5 1; -5 3; -1 5; -3 5]; 
         points_q3 = [-1 -1; -1 -3; -3 -1; -3 -3; -5 -1; -5 -3; -1 -5; -3 -5]; 
         points_q4 = [1 -1; 1 -3; 3 -1; 3 -3; 5 -1; 5 -3; 1 -5; 3 -5];
         gray_labels = [0, 1, 3, 2, 4, 5, 7, 6, 12, 13, 15, 14, 8, 9, 11, 10, 16, 17, 19, 18, 20, 21, 23, 22, 24, 25, 27, 26, 28, 29, 31, 30];
         points = [points_q1; points_q2; points_q3; points_q4];
    elseif M == 64
        points_q1 = [1 1; 1 3; 3 1; 3 3; 5 1; 5 3; 7 1; 7 3; 1 5; 1 7; 3 5; 3 7; 5 5; 5 7; 7 5; 7 7]; 
        points_q2 = [-1 1; -1 3; -3 1; -3 3; -5 1; -5 3; -7 1; -7 3; -1 5; -1 7; -3 5; -3 7; -5 5; -5 7; -7 5; -7 7]; 
        points_q3 = [-1 -1; -1 -3; -3 -1; -3 -3; -5 -1; -5 -3; -7 -1; -7 -3; -1 -5; -1 -7; -3 -5; -3 -7; -5 -5; -5 -7; -7 -5; -7 -7]; 
        points_q4 = [1 -1; 1 -3; 3 -1; 3 -3; 5 -1; 5 -3; 7 -1; 7 -3; 1 -5; 1 -7; 3 -5; 3 -7; 5 -5; 5 -7; 7 -5; 7 -7];
        gray_labels = [0, 1, 3, 2, 4, 5, 7, 6, 12, 13, 15, 14, 8, 9, 11, 10, 16, 17, 19, 18, 20, 21, 23, 22, 24, 25, 27, 26, 28, 29, 31, 30, 48, 49, 51, 50, 52, 53, 55, 54, 60, 61, 63, 62, 56, 57, 59, 58, 32, 33, 35, 34, 36, 37, 39, 38, 44, 45, 47, 46, 40, 41, 43, 42];
         points = [points_q1; points_q2; points_q3; points_q4];
     elseif M == 128
         points_q1 = [1 1; 1 3; 3 1; 3 3; 5 1; 5 3; 7 1; 7 3; 1 5; 1 7; 3 5; 3 7; 5 5; 5 7; 7 5; 7 7; 1 9; 1 11; 3 9; 3 11; 5 9; 5 11; 7 9; 7 11; 1 13; 1 15; 3 13; 3 15; 5 13; 5 15; 7 13; 7 15];
         points_q2 = [-1 1; -1 3; -3 1; -3 3; -5 1; -5 3; -7 1; -7 3; -1 5; -1 7; -3 5; -3 7; -5 5; -5 7; -7 5; -7 7; -1 9; -1 11; -3 9; -3 11; -5 9; -5 11; -7 9; -7 11; -1 13; -1 15; -3 13; -3 15; -5 13; -5 15; -7 13; -7 15];
         points_q3 = [-1 -1; -1 -3; -3 -1; -3 -3; -5 -1; -5 -3; -7 -1; -7 -3; -1 -5; -1 -7; -3 -5; -3 -7; -5 -5; -5 -7; -7 -5; -7 -7; -1 -9; -1 -11; -3 -9; -3 -11; -5 -9; -5 -11; -7 -9; -7 -11; -1 -13; -1 -15; -3 -13; -3 -15; -5 -13; -5 -15; -7 -13; -7 -15];
         points_q4 = [1 -1; 1 -3; 3 -1; 3 -3; 5 -1; 5 -3; 7 -1; 7 -3; 1 -5; 1 -7; 3 -5; 3 -7; 5 -5; 5 -7; 7 -5; 7 -7; 1 -9; 1 -11; 3 -9; 3 -11; 5 -9; 5 -11; 7 -9; 7 -11; 1 -13; 1 -15; 3 -13; 3 -15; 5 -13; 5 -15; 7 -13; 7 -15];
         gray_labels = [0, 1, 3, 2, 4, 5, 7, 6, 12, 13, 15, 14, 8, 9, 11, 10, 16, 17, 19, 18, 20, 21, 23, 22, 24, 25, 27, 26, 28, 29, 31, 30, 48, 49, 51, 50, 52, 53, 55, 54, 60, 61, 63, 62, 56, 57, 59, 58, 32, 33, 35, 34, 36, 37, 39, 38, 44, 45, 47, 46, 40, 41, 43, 42, 64, 65, 67, 66, 68, 69, 71, 70, 76, 77, 79, 78, 72, 73, 75, 74, 80, 81, 83, 82, 84, 85, 87, 86, 88, 89, 91, 90, 92, 93, 95, 94, 112, 113, 115, 114, 116, 117, 119, 118, 124, 125, 127, 126, 120, 121, 123, 122, 96, 97, 99, 98, 100, 101, 103, 102, 108, 109, 111, 110, 104, 105, 107, 106];
         points = [points_q1; points_q2; points_q3; points_q4];
    else
        points = [];
        gray_labels = [];
        error('Invalid QAM size. Please choose from 4, 16, 32, 64, 128');
    end

    % Convertir les labels Gray en strings pour l'affichage
     gray_strings = cellstr(num2str(gray_labels'));
       
    % Calcul de l'énergie centrée sur (0,0)
    energy = sqrt(points(:,1).^2 + points(:,2).^2);
    phase = atan2(points(:,2), points(:,1));
    phase = mod(phase + 2*pi, 2*pi);
    phase_pi = phase / pi;
   
    % --- Ajout de bruit ---
    signal_power = mean(energy.^2); % Puissance moyenne du signal
    noise_power = signal_power / (10^(SNR/10)); % Puissance du bruit en fonction du SNR
    noise = sqrt(noise_power/2) * (randn(size(points)) + 1i*randn(size(points))); % Bruit gaussien complexe

    points_noisy = points + noise; % Points de la constellation avec bruit
    
    % --- Diagramme de constellation ---
    figure;

    subplot(1,2,1);
    hold on;
    scatter(points(:,1), points(:,2), 'filled', 'b');
    if ~isempty(excluded_points)
        scatter(excluded_points(:,1), excluded_points(:,2), 'r', 'x');
    end
    grid on;
    title(sprintf('%d-QAM Constellation Diagram', M));
    xlabel('In-Phase (I)');
    ylabel('Quadrature (Q)');
    axis equal;
    
    % Affichage des symboles Gray et cercles autour des points
      for i = 1:length(points)
            text(points(i, 1), points(i, 2), gray_strings{i}, 'FontSize', 8, 'VerticalAlignment', 'bottom');
           plot_circle(points(i, 1), points(i, 2), 0.5, 'r');
      end
      
    max_val = max(abs(points), [], 'all') + 2;
    ticks = -max_val:2:max_val;
    set(gca, 'XTick', ticks(ticks ~= 0), 'YTick', ticks(ticks ~= 0));
    plot([-max_val, max_val], [0, 0], 'k', 'LineWidth', 1.2);
    plot([0, 0], [-max_val, max_val], 'k', 'LineWidth', 1.2);
    hold off;

    subplot(1,2,2);
    hold on;
    scatter(real(points_noisy), imag(points_noisy), 'filled', 'r'); % Points bruités en rouge
    if ~isempty(excluded_points)
        scatter(real(excluded_points), imag(excluded_points), 'r', 'x');
    end
    grid on;
    title(sprintf('%d-QAM Constellation Diagram with Noise (SNR = %d dB)', M, SNR));
    xlabel('In-Phase (I)');
    ylabel('Quadrature (Q)');
    axis equal;
    
      % Affichage des symboles Gray et cercles autour des points
       for i = 1:length(points_noisy)
            text(real(points_noisy(i)), imag(points_noisy(i)), gray_strings{i}, 'FontSize', 8, 'VerticalAlignment', 'bottom');
           plot_circle(real(points_noisy(i)), imag(points_noisy(i)), 0.5, 'r');
      end
     
    max_val = max(abs(points_noisy), [], 'all') + 2;
    ticks = -max_val:2:max_val;
    set(gca, 'XTick', ticks(ticks ~= 0), 'YTick', ticks(ticks ~= 0));
    plot([-max_val, max_val], [0, 0], 'k', 'LineWidth', 1.2);
    plot([0, 0], [-max_val, max_val], 'k', 'LineWidth', 1.2);
    hold off;

    % Affiche l'énergie et la phase dans la fenêtre de commande
    fprintf('Symbol\tQ\tI\tEnergy\tPhase (rad)\n');
    for i = 1:length(points)
        fprintf('%d\t%d\t%d\t%.2f\t%.2fπ\n', i, points(i,2), points(i,1), energy(i), phase_pi(i));
    end

    % --- Calcul du BER ---
    % Quantification des points bruités
    quantized_points = round(points_noisy);
    % Calcul du taux d'erreur sur les bits
    bit_errors = sum(points(:) ~= quantized_points(:));
    ber = bit_errors / numel(points);
    fprintf('Bit Error Rate (BER): %.5f\n', ber);
end

% Entrée utilisateur pour la taille de la constellation QAM
M = input('Enter the size of QAM (4, 16, 32, 64, 128): ');
SNR = input('Enter the Signal-to-Noise Ratio (SNR) in dB: ');
valid_sizes = [4, 16, 32, 64, 128];
if ismember(M, valid_sizes)
    disp('Generating QAM constellation with noise and displaying symbol information...');
    plot_qam_constellation(M, SNR);
else
    fprintf('Invalid QAM size. Please choose from: %s\n', num2str(valid_sizes));
end