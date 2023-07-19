FROM debian:bookworm as install_apps
WORKDIR /tmp/dotfiles/
COPY install-apps.sh ./
RUN bash install-apps.sh

FROM install_apps as install_dotfiles
WORKDIR /tmp/dotfiles
COPY dotfiles ./dotfiles
COPY install-dotfiles.sh ./
RUN bash install-dotfiles.sh "/tmp/dotfiles"

FROM install_dotfiles
WORKDIR /root
EXPOSE 22/tcp
COPY docker-entrypoint.sh ./
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["zsh"]
