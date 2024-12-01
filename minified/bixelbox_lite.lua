local e={initialized=false,shared_data={},internal={}}local t={}local a={}local
o=table.concat local function i()for n=0,15 do a[2^n]=("%x"):format(n)end end
e.internal.to_blit_lookup=a e.internal.generate_lookups=i function
e.make_canvas_scanline(s)return setmetatable({},{__newindex=function(h,r,d)if
type(r)=="number"and r%1~=0 then
error(("Tried to write a float pixel. x:%s y:%s"):format(r,s),2)else
rawset(h,r,d)end end})end function e.make_canvas(l)local
u=e.make_canvas_scanline("NONE")local c=getmetatable(u)function
c.tostring()return"pixelbox_dummy_oob"end return setmetatable(l
or{},{__index=function(m,f)if type(f)=="number"and f%1~=0 then
error(("Tried to write float scanline. y:%s"):format(f),2)end return u end})end
function e.setup_canvas(w,y,p,v)for b=1,w.height do local g if not
rawget(y,b)then g=e.make_canvas_scanline(b)rawset(y,b,g)else g=y[b]end for
k=1,w.width do if not(g[k]and v)then g[k]=p end end end return y end function
e.restore(q,j,x,z)if not x then local
E=e.setup_canvas(q,e.make_canvas(),j)q.canvas=E q.CANVAS=E else
e.setup_canvas(q,q.canvas,j,z)end end local T=string.rep function
t:render()local A=self.term local O,I=A.blit,A.setCursorPos local
N=self.term_height local S=self.canvas local H,R={},{}local D,L={},{}local
U,C=self.x_offset,self.y_offset local M,F=self.width,self.height local
W=T("\131",M)local Y=T("\143",M)local P=0 for V=1,F,3 do P=P+2 local
B=S[V]local G=S[V+1]local K=S[V+2]local Q=1 for J=1,M do local X=B[J]local
Z=G[J]local et=K[J]H[Q]=a[X]R[Q]=a[Z]D[Q]=a[Z]L[Q]=a[et or Z]Q=Q+1 end
I(1+U,C+P-1)O(Y,o(H,""),o(R,""))if P<=N then I(1+U,C+P)O(W,o(D,""),o(L,""))end
end end function t:clear(tt)e.restore(self,a[tt or""]and tt or
self.background,true,false)end function
t:set_pixel(at,ot,it)self.canvas[ot][at]=it end function
t:set_canvas(nt)self.canvas=nt self.CANVAS=nt end function
t:resize(st,ht,rt)self.term_width=math.floor(st+0.5)self.term_height=math.floor(ht+0.5)self.width=math.floor(st+0.5)self.height=math.floor(ht*(3/2)+0.5)e.restore(self,rt
or self.background,true,true)end function e.module_error(dt,lt,ut,ct)ut=ut or 1
if dt.__contact and not ct then local
mt,ft=pcall(error,lt,ut+2)printError(ft)error((dt.__report_msg
or"\nReport module issue at:\n-> __contact"):gsub("[%w_]+",dt),0)elseif not ct
then error(lt,ut+1)end end function t:load_module(wt)for yt,pt in ipairs(wt
or{})do local
vt={__author=pt.author,__name=pt.name,__contact=pt.contact,__report_msg=pt.report_msg}local
bt,gt=pt.init(self,vt,e,e.shared_data,e.initialized,wt)gt=gt or{}vt.__fn=bt if
self.modules[pt.id]and not wt.force then
e.module_error(vt,("Module ID conflict: %q"):format(pt.id),2,wt.supress)else
self.modules[pt.id]=vt if gt.verified_load then gt.verified_load()end end for
kt in pairs(bt)do if self.modules.module_functions[kt]and not wt.force then
e.module_error(vt,("Module %q tried to register already existing element: %q"):format(pt.id,kt),2,wt.supress)else
self.modules.module_functions[kt]={id=pt.id,name=kt}end end end end function
e.new(qt,jt,xt)local zt={modules={module_functions={}}}zt.background=jt or
qt.getBackgroundColor()local Et,Tt=qt.getSize()zt.term=qt
setmetatable(zt,{__index=function(At,Ot)local
It=rawget(zt.modules.module_functions,Ot)if It then return
zt.modules[It.id].__fn[It.name]end return
rawget(t,Ot)end})zt.__bixelbox_lite=true zt.term_width=Et zt.term_height=Tt
zt.width=Et zt.height=math.ceil(Tt*(3/2))zt.x_offset=0 zt.y_offset=0
e.restore(zt,zt.background)if type(xt)=="table"then zt:load_module(xt)end if
not e.initialized then i()e.initialized=true end return zt end return
e