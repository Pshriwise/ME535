function [radius] = get_circle_rad(u)

    start_radius = 1;
    radius = start_radius*(-2.08*u^3+3.75*u^2-2.667*u+1);