function [R, AUC, closest, thr, F] = get_roc(scores, groundtruth)
%GET_ROC Summary of this function goes here
%   Detailed explanation goes here


R = []
n = length(scores)

% sort examples by decreasing score
%{
for j=1:1:n-1
    for i=1:1:n-1
        if scores(i)<scores(i+1);
            tempS=scores(i);
            scores(i)=scores(i+1);
            scores(i+1)=tempS;
            tempG=groundtruth(i);
            groundtruth(i)=groundtruth(i+1);
            groundtruth(i+1)=tempG;
        end
    end
end
%}
[sorted, idx] = sort(scores, 'descend');
scores = sorted;
groundtruth = groundtruth(idx);

scores
groundtruth

% count P and N
c = [0 0];
for i = 1:n
    c(groundtruth(i)+1) = c(groundtruth(i)+1) + 1;
end
P = c(2);
N = c(1);


TP = 0;
FP = 0;
TP_prev = 0;
FP_prev = 0;
AUC = 0;
min_dist = 9999;
closest = [0 1];
thr = 0;
F = 0;
s_prev = 9999;
% get ROC points
for i = 1:n
    s = scores(i);
    g = groundtruth(i);
    if s ~= s_prev
        R = [R; [FP/N TP/P]];
        AUC = AUC + trap(FP,FP_prev,TP,TP_prev);
        if dist(FP/N, TP/P, 0, 1) < min_dist
            min_dist = dist(FP/N, TP/P, 0, 1);
            closest = [FP/N, TP/P];
            F = 2 / (P/TP + (TP+FP)/TP);
            thr = s;
        end
        s_prev = s;
        TP_prev = TP;
        FP_prev = FP;
    end
    if g == 1
        TP = TP + 1;
    else
        FP = FP + 1;
    end
end
R = [R; [FP/N TP/P]];
AUC = AUC + trap(FP,FP_prev,TP,TP_prev);
AUC = AUC / (P*N)
min_dist
closest
thr
F



end



function A = trap(x1, x2, y1, y2)
A = abs(x1-x2) * ((y1+y2)/2);
end

function D = dist(x1, y1, x2, y2)
D = sqrt((x1-x2)^2+(y1-y2)^2);
end

