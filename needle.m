function needle(d, l, n, nr_needles, nr_lines)
% d - distance between lines
% l - the length of the needle
% n - the number of dropped needles
fav=0;

% drawing n straight lines
line=zeros(1, nr_lines);
for i=1:nr_lines
    line(i)=i*d; % d is the distance between the lines
    plot3([line(i), line(i)], [d/2-l/2, nr_lines*d+d/2+l/2], [0, 0], 'color', 'k', 'linewidth', 1.02);
    hold on;
end
title("Buffon's Needle Problem");
xlabel('x');
ylabel('y');
zlabel('z');
for i=1:n
    ok=0;
    % the final position of the needle's center can be between d/2 and d/2+2*d
    x0 = d/2 + (d/2+nr_lines*d -d/2)*rand(1);
    y0 = d/2 + (d/2+nr_lines*d -d/2)*rand(1);
    
    % the angle between 0 and 360 degrees where I generate the (x, y) coordinates
    alpha = 2*pi*rand(1);
    % the upper endpoint (since I am raising this to z2) -> z2 moves downward first
    x1_final = x0 + l/2*cos(alpha);
    y1_final = y0 + l/2*sin(alpha);
    
    x2_final = x0 + l/2*cos(alpha + pi); % the lower endpoint
    y2_final = y0 + l/2*sin(alpha + pi);

    % checking if it intersects either of the two lines
    for j=1:nr_lines % does it intersect any of the lines?
        if ((x1_final<=line(j) && x2_final>=line(j)) || (x2_final<=line(j) && x1_final>=line(j)))
            fav=fav+1;
            ok=1;
        end
    end
    if (i<=nr_needles) % I drop nr_needles needles
        % the angle of inclination of the needle as it falls 
        % (according to which I calculate the coordinates (x1, y1)
        % relative to the fixed coordinates (x2, y2))
        theta = (pi/2)*rand(1);
        
        % the height of z1 relative to z2 (according to the angle theta)
        bef1 = l * sin(theta);
        bef2 = sqrt(l^2 - bef1^2); % the length of the other leg
        z2 = 10; % initial dropping height of z2
        z1 = z2 + bef1; % initial dropping height of z1
        
        % the initial state of the lower endpoint is
        % the same as the final state
        x2 = x2_final;
        y2 = y2_final;
        x1 = x2 + bef2*cos(alpha); % position of x1 relative to x2
        y1 = y2 + bef2*sin(alpha);
        
        h = plot3([x1, x2], [y1 y2], [z1 z2], 'r', 'linewidth', 1.02);
        axis([d/2-l/2   nr_lines*d+d/2+l/2   d/2-l/2   nr_lines*d+d/2+l/2 0   z2+l]);
        while (z2>0)
            delete(h);
            h = plot3([x1, x2], [y1 y2], [z1 z2], 'r', 'linewidth', 1.02);
            pause(0.002);
            z1=z1-0.1;
            z2=z2-0.1;
        end
        z2=0;
        %pause(2);
        while (theta > 0) % the needle leans
            theta=theta-0.1;
            if (theta<0)
                theta = 0;
            end
            bef1 = l * sin(theta);
            bef2 = sqrt(l^2 - bef1^2);
            x1 = x2 + bef2*cos(alpha);
            y1 = y2 + bef2*sin(alpha);
            z1 = z2 + bef1;
            delete(h);
            h = plot3([x1, x2], [y1 y2], [z1 z2], 'r', 'linewidth', 1.02);
            pause(0.01);
            %pause(2);
        end
        if (ok==1) % intersect
            delete(h);
            plot3([x1_final, x2_final], [y1_final y2_final], [0 0], 'g', 'linewidth', 1.02);
        else % does not intersect
            delete(h);
            plot3([x1_final x2_final], [y1_final y2_final], [0 0], 'r', 'linewidth', 1.02);
        end
    end
end
disp ((n*2*l)/(d*fav))