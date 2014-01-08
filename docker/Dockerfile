FROM ubuntu:12.10 

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN apt-get update
RUN apt-get install rtorrent openssh-server tmux -y
RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd
ADD authorized_keys /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
