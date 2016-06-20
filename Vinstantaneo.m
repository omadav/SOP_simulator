function V=Vinstantaneo(lmas, lmenos, a1c, a1u, a2u)
  Vmas=lmas*a1c*a1u;
  Vmenos=lmenos*a1c*a2u;
  V=Vmas-Vmenos;