
w<-rep(1000,8)# coffiecients for hard constraints
z<-rep(1,7)# coefficients for soft constraints

objective_function<-function(conference,w,z)
{
  h<-as.numeric(hard_constraints(conference))
  s<-as.numeric(Soft_constraints(conference))
  
  obj<-sum(h*w)+sum(s*z)
  obj
}