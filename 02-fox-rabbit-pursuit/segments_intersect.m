function tf = segments_intersect(P1, P2, Q1, Q2)
% Check if line segments P1P2 and Q1Q2 intersect (touching counts).
% Uses the signs of 2D cross products: the segments cross when the
% endpoints of each segment lie on opposite sides of the other one.

a = (Q2(1) - Q1(1)) * (P1(2) - Q1(2)) - (Q2(2) - Q1(2)) * (P1(1) - Q1(1));
b = (Q2(1) - Q1(1)) * (P2(2) - Q1(2)) - (Q2(2) - Q1(2)) * (P2(1) - Q1(1));
c = (P2(1) - P1(1)) * (Q1(2) - P1(2)) - (P2(2) - P1(2)) * (Q1(1) - P1(1));
d = (P2(1) - P1(1)) * (Q2(2) - P1(2)) - (P2(2) - P1(2)) * (Q2(1) - P1(1));

tf = ((a >= 0 && b <= 0) || (a <= 0 && b >= 0)) && ...
     ((c >= 0 && d <= 0) || (c <= 0 && d >= 0));
end
