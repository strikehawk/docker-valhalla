# Take the official valhalla runner image,
# remove a few superfluous things and
# create a new runner image from ubuntu:20.04
# with the previous runner's artifacts

FROM valhalla/valhalla:run-3.1.2 as builder

# remove some stuff from the original image
RUN cd /usr/local/bin && \
  preserve="valhalla_service valhalla_export_edges valhalla_build_tiles valhalla_build_config valhalla_build_admins valhalla_build_timezones valhalla_build_elevation valhalla_ways_to_edges valhalla_build_extract" && \
  mv $preserve .. && \
  for f in valhalla*; do rm $f; done && \
  cd .. && mv $preserve ./bin

FROM ubuntu:20.04 as runner

RUN apt-get update > /dev/null && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y libboost-program-options1.71.0 libluajit-5.1-2 \
      libzmq5 libczmq4 spatialite-bin libprotobuf-lite17 \
      libsqlite3-0 libsqlite3-mod-spatialite libgeos-3.8.0 libcurl4 \
      python3.8-minimal python3-distutils curl unzip parallel jq spatialite-bin > /dev/null && \
    ln -sf /usr/bin/python3.8 /usr/bin/python && \
    ln -sf /usr/bin/python3.8 /usr/bin/python3

COPY --from=builder /usr/local /usr/local
COPY --from=builder /usr/bin/prime_* /usr/bin/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libprime* /usr/lib/x86_64-linux-gnu/

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
# export the True defaults
ENV use_tiles_ignore_pbf=True
ENV build_tar=True

COPY scripts/runtime/. /valhalla/scripts
RUN chmod +x /valhalla/scripts/run.sh && chmod +x /valhalla/scripts/configure_valhalla.sh && chmod +x /valhalla/scripts/generate_only.sh

# Expose the necessary port
EXPOSE 8002
ENTRYPOINT ["/valhalla/scripts/run.sh"]
CMD ["build_tiles"]
