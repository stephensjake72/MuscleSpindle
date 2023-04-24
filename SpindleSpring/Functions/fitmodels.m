function models = fitmodels(data, type)
st = data.spiketimes;
ifr = data.ifr;
Lf = data.Lf;
Lmt = data.Lmt;
vf = data.vf;
vmt = data.vmt;
Fmt = data.Fmt;
time = data.time;

if strcmp(type, 'ramp')
    startT = 1.2;
elseif strcmp(type, 'triangle')
    startT = 2.5;
elseif strcmp(type, 'sine')
    startT = 1.5;
end

keep1 = time > startT;
keep2 = st > startT;

st = st(keep2);
ifr = ifr(keep2);
time = time(keep1);
Lmt = Lmt(keep1);
vmt = vmt(keep1);
Lf = Lf(keep1);
vf = vf(keep1);
Fmt = Fmt(keep1);

Lfst = interp1(time, Lf, st);
vfst = interp1(time, vf, st);
Lmtst = interp1(time, Lmt, st);
vmtst = interp1(time, vmt, st);
Fmtst = interp1(time, Fmt, st);

Lfmod = fitlm(Lfst, ifr);
vfmod = fitlm(vfst, ifr);
Lmtmod = fitlm(Lmtst, ifr);
vmtmod = fitlm(vmtst, ifr);
Fmtmod = fitlm(Fmtst, ifr);

pLf = corrcoef(Lfmod.Coefficients.Estimate(2)*Lfst + Lfmod.Coefficients.Estimate(1), ifr);
pvf = corrcoef(vfmod.Coefficients.Estimate(2)*vfst + vfmod.Coefficients.Estimate(1), ifr);
pLmt = corrcoef(Lmtmod.Coefficients.Estimate(2)*Lmtst + Lmtmod.Coefficients.Estimate(1), ifr);
pvmt = corrcoef(vmtmod.Coefficients.Estimate(2)*vmtst + vmtmod.Coefficients.Estimate(1), ifr);
pFmt = corrcoef(Fmtmod.Coefficients.Estimate(2)*Fmtst + Fmtmod.Coefficients.Estimate(1), ifr);

models.mLf = Lfmod.Coefficients.Estimate(2);
models.bLf = Lfmod.Coefficients.Estimate(1);
models.rLf = Lfmod.Rsquared.Ordinary;
models.mvf = vfmod.Coefficients.Estimate(2);
models.bvf = vfmod.Coefficients.Estimate(1);
models.rvf = vfmod.Rsquared.Ordinary;
models.mLmt = Lmtmod.Coefficients.Estimate(2);
models.bLmt = Lmtmod.Coefficients.Estimate(1);
models.rLmt = Lmtmod.Rsquared.Ordinary;
models.mvmt = vmtmod.Coefficients.Estimate(2);
models.bvmt = vmtmod.Coefficients.Estimate(1);
models.rvmt = vmtmod.Rsquared.Ordinary;
models.mFmt = Fmtmod.Coefficients.Estimate(2);
models.bFmt = Fmtmod.Coefficients.Estimate(1);
models.rFmt = Fmtmod.Rsquared.Ordinary;