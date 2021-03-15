G = [1 0 1 1 1 0 0 0];
C1 = [0.5 0.3 0.6 0.22 0.4 0.51 0.2 0.33]
C2 = [0.04 0.1 0.68 0.22 0.4 0.11 0.8 0.53]

figure(9)
[roc1, AUC1, closest1, thr1, F1] = get_roc(C1, G)
plot(roc1(:,1), roc1(:,2))
[roc2, AUC2, closest2, thr2, F2] = get_roc(C2, G)
hold on, plot(roc2(:,1), roc2(:,2)), title(sprintf('C1: t = %1.3g, F = %1.3g, AUC = %1.3g  &  C2: t = %1.3g, F = %1.3g, AUC = %1.3g', thr1, F1, AUC1, thr2, F2, AUC2));