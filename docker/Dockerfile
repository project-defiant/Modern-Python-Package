FROM python:3.10-bullseye
LABEL org.opencontainers.image.source https://github.com/GordionBio/Ptolemy

ARG VERSION=latest
ENV package="template-${VERSION}-py3-none-any.whl"
COPY docker/${package}  ${package}
RUN pip install ${package}
