FROM wallaskrea/alpineminiglib
# Dockerfile.alpine-glib-jupyter

LABEL \
    Description="Jupyterlab container image with main python data analysis libraries setup" \
    Mantainer="William Trigos <ing.william.trigos@gmail.com>" \
    Inspired_by="https://github.com/datarevenue-berlin/alpine-miniconda"

# Configure environment
ENV MINICONDA_VER="4.7.12" \
    MINICONDA_MD5_SUM="0dba759b8ecfc8948f626fa18785e3d8" \
    CONDA_DIR="/opt/conda" \
    CONTAINER_USER="jupylab"

# Install glibc and useful packages
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk --update add \
    bash \
    curl \
    ca-certificates \
    libstdc++ \
    # glib \
    # # tini@testing \
    # && curl "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" -o /etc/apk/keys/sgerrand.rsa.pub \
    # && curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk" -o glibc.apk \
    # && apk add --allow-untrusted glibc.apk \
    # && curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk" -o glibc-bin.apk \
    # && apk add --allow-untrusted glibc-bin.apk \
    # && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk" -o glibc-i18n.apk \
    # && apk add --allow-untrusted glibc-i18n.apk \
    # && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    # && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib \
    # && rm -rf glibc*apk 
    && rm -rf /var/cache/apk/*


ENV PATH="$CONDA_DIR/bin:$PATH" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    MINICONDA_URL="https://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VER-Linux-x86_64.sh"

# Create user with UID=1000 and in the 'users' group
RUN adduser -s /bin/bash -u 1000 -D $CONTAINER_USER && \
    mkdir -p /opt/conda && \
    chown $CONTAINER_USER /opt/conda

RUN mkdir /home/$CONTAINER_USER && \
    mkdir /home/$CONTAINER_USER/Notebooks && \
    mkdir /home/$CONTAINER_USER/.jupyter && \
    mkdir /home/$CONTAINER_USER/.local

RUN chown -R $CONTAINER_USER:users /home/$CONTAINER_USER/Notebooks

USER $CONTAINER_USER

# Install conda
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    curl -L $MINICONDA_URL  -o miniconda.sh && \
    echo "$MINICONDA_MD5_SUM  miniconda.sh" | md5sum -c - && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda install --yes conda==$MINICONDA_VER 
 
RUN conda upgrade -y pip && \
    conda config --add channels conda-forge && \
    conda clean --all

# install data analysis packages    
RUN conda install -y \
        nomkl \
        jupyterlab \
        numpy \
        pandas \
        matplotlib \
        && conda clean -yt

# Userful customization for jupyter (plugin tools)
# RUN conda install -c conda-forge jupyterlab
# RUN jupyter serverextension enable --py jupyterlab --sys-prefix
#  
# RUN conda install -c conda-forge jupyter_contrib_nbextensions
# RUN jupyter contrib nbextension install --user

# final setups and default command
EXPOSE 8888
WORKDIR $HOME/$CONTAINER_USER/Notebooks
COPY ./jupylab_config.py $HOME/$CONTAINER_USER/jupyter_notebook_config.py
CMD jupyter lab --config=$HOME/$CONTAINER_USER/jupyter_notebook_config.py
USER $CONTAINER_USER
