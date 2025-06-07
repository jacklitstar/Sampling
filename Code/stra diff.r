diff.mean = function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha)
{
  N = sum(Nh)
  Wh = Nh/sum(Nh)
}





diff.total = function(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
{
  N = sum(Nh)
  Wh = Nh/sum(Nh)
  stra.num=length(Nh)

  yst.result=stra.srs.mean2(Nh, y.sample, stra.index, alpha)$mean.result
  xst.result=stra.srs.mean2(Nh, x.sample, stra.index, alpha)$mean.result

  Yst = N * yst.result$mean.est
  Xst = N * xst.result$mean.est


  nh  =rep(0, stra.num)
  sy2 =rep(0, stra.num)
  sx2 =rep(0, stra.num)
  syx =rep(0, stra.num)
  variance =rep(0, stra.num)


  for (h in 1:stra.num)
  {
  y.hth=y.sample[stra.index==h]
  x.hth=x.sample[stra.index==h]
    
  nh[h]=length(y.hth)

  sy2[h] =var(y.hth)
  sx2[h] =var(x.hth)
  syx[h]=cov(y.hth, x.hth)
  }
  fh=nh/Nh
  for(h in 1:stra.num)
  {
    variance[h] = Nh[h]^2 * (1 - fh[h]) * (sy2[h] - 2 * syx[h] +  sx2[h]) / nh[h]
  }

  Ydiff.est = Yst + Xbar * N - Xst
  Ydiff.var = sum(variance)
  Ydiff.sd  = sqrt(Ydiff.var)
  Ydiif.ci = conf.interval(Ydiff.est, Ydiff.sd, alpha)
  Ydiff.left = Ydiif.ci$left
  Ydiff.right= Ydiif.ci$right
  Ydiff.result=matrix(c(Ydiff.est, Ydiff.var, Ydiff.sd, Ydiff.left, Ydiff.right), nrow=1)
  colnames(Ydiff.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(Ydiff.result)=c("TOTAL_DIFF")
  return(Ydiff.result)

}