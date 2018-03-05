# Intro to R and RStudio
## NICAR 2018 Session on Saturday March 10, 9 am
### Sharon Machlis

This repo includes R scripts that will be on laptops in my NICAR hands-on session Saturday morning introducing R and RStudio.

I can't predict how many people might show up to a repeat session early on a Saturday morning :-) But if you know that you might want to attend and are worried that you may end up in the room but not at a session laptop, I figured I'd post the files in advance. So, if you are interested in setting up your own laptops in advance for the session, here's how. (Note: You probably want to do this sometime _before_ the session starts, given the vagaries of hotel Internet connections.)

1. Download R from [https://cran.rstudio.com/](https://cran.rstudio.com/), choosing the binary distribution for your operating system. Install it as you would any other software program.

2. Download the free, open-source version of RStudio Desktop (not server) from the [RStudio website](https://www.rstudio.com/products/rstudio/download/). Install it as you would any other software program.

3. Open RStudio. Type the following line of code in the bottom left panel at the `>` prompt:

```
install.packages("pacman")
```

and hit return or enter. This installs an external R library called pacman that's useful for installing _other_ packages.

4. When that finishes, type the following line of code at the `>` prompt:

```
install.packages("usethis")
```

and hit return or enter. As you might have guessed, that installs an external R library called usethis.

5. When _that_ finishes, type (or cut and paste) this code at the `>` prompt:

```
usethis::use_course("https://github.com/smach/NICAR2018IntroToR/archive/master.zip")
```
This should download all the session files to your local system, and create a new project for them within RStudio.



