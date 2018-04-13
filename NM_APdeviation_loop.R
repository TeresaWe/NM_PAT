
# Formula from Dohn, 2012: they used 768 steps on the scroll wheel per octave. 
#Therefore they have a complicated way to measure the distance between target and selected frequency in cent (modulo etc.)
#c=(((log2(fselected/ftarget)*Nsteps+Nsteps/2) Mod(Nsteps)-Nsteps/2)*1200/Nsteps)
# e.g. c = (((log2(451.3616/440)*768+768/2)Mod(768)-768/2)*1200/768)
#c=(Mod((log2(451.3616/440)*1200+(1200/2))/1200)-(1200/2))*1200/1200 #(in R)


# for us, the short part is sufficient,as we have a resolution of 1200 cent per octave (100 per semitone)
# this ist: log2(fselected/ftarget)*1200
# e.g. log2(466.164/440)*1200 --> 100.0009
# log2(932.328/880)*1200 --> 100.0009


# lookup table frequencies: (CAUTION:lookup takes position of letter/factor level, if not changed to class character!
big_nm<-c("C"=65.4064, "Cis"=69.2957, "D"=73,4162, "Dis"=77.7817, "E"=82.4069, "F"=87.3071, "Fis"=92.4986,
          "G"=97.9989, "Gis"=103.826, "A"=110.000, "B"=116.541, "H"=123.471)
small_nm<-c("C"=130.813, "Cis"=138.591, "D"=146.832, "Dis"=155.563, "E"=164.814, "F"=174.614, "Fis"=184.997,
         "G"=195.998, "Gis"=207.652, "A"=220.000, "B"=233.082, "H"=246.942)
one_nm<-c( "C"=261.626, "Cis"=277.183, "D"= 293.665, "Dis"= 311.127, "E"=329.628, "F"=349.228, "Fis"=369.994,
       "G"=391.995, "Gis"=415.305, "A"=440.000,"B"=466.164, "H"=493.883)
two_nm<-c("C"=523.251, "Cis"=554.365, "D"= 587.330, "Dis"= 622.254, "E"=659.255, "F"=698.456, "Fis"=739.989,
       "G"=783.991, "Gis"=830.609,"A"=880.000, "B"=932.328, "H"=987.767)
three_nm<-c("C"=1046.50, "Cis"=1108.73, "D"=1174.66, "Dis"=1244.51, "E"=1318.51, "F"=1396.91, "Fis"=1479.98,
         "G"=1567.98, "Gis"=1661.22, "A"=1760.00, "B"=1864.66, "H"=1975.53)

file_list_raw = ls(pattern="^NM_PAT_[A-Z]{2}[0-9]{2}[A-Z]{3}[0-9]{3}")
name_lookup<-vector(mode= "character", length=length(file_list_raw))
for (j in seq_along(file_list_raw)) {
  #rm(dev_raw, vec, nam)
  dev_raw = get(file_list_raw[[j]])
  nam <- paste("dev_", file_list_raw[[j]], sep = "")
  vec<-numeric(144) #table
  for (i in 1:144) {
    entered<-as.numeric(dev_raw[i,4]) #table
    label<-dev_raw[i,6] #table
    target<-dev_raw$target.note # column name sometimes changes depending on type of read in...
    target<-as.character(target)
    label<-as.character(label)
    l_big<-unname(big_nm[label])
    l_sm<-unname(small_nm[label])
    l_one<-unname(one_nm[label])
    l_two<-unname(two_nm[label])
    l_three<-unname(three_nm[label])
    distance<-log2(entered/c(l_big,l_sm,l_one,l_two,l_three))*1200 #distanzen zu zieltönen in verschiedenen Oktaven
    abs_distance<-abs(distance) #Betrag
    octave<-which(abs_distance==min(abs_distance))
    c<-distance[octave]
    vec[i]<-c #table
    assign(nam, data.frame(vec,dev_raw$target.note,target)) #into data frame
    #col.names=c("c","note")
    i=i+1
  }
  j=j+1
}