#BASE chef/ubuntu-12.04:latest
FROM chef/ubuntu-12.04
ADD chef/ /etc/chef/
EXPOSE 80
RUN chef-init --bootstrap
RUN rm -rf /etc/chef/secure/*
ENTRYPOINT ["chef-init"]
CMD ["--onboot"]
