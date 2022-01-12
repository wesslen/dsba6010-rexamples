FROM rocker/binder:latest

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

#RUN adduser --disabled-password \
#    --gecos "Default user" \
#    --uid ${NB_UID} \
#    ${NB_USER}

# Copy your repository contents to the image
# COPY --chown=rstudio:rstudio . ${HOME}
RUN R -e "install.packages('tidyverse', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('brms', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('osfr', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('cmdstanr', repos = c('https://mc-stan.org/r-packages/', getOption('repos')))"
RUN R -e "devtools::install_github('rmcelreath/rethinking')"

# install cmdstanr
RUN mkdir -p /workspace/.cmdstanr
ENV PATH="/workspace/.cmdstanr:${PATH}"
RUN R -e "cmdstanr::install_cmdstan(dir = '/workspace/.cmdstanr', cores = 2)"

#RUN if [ -f install.R ]; then R --quiet -f install.R; fi