FROM debian:8.1

RUN apt-get update && apt-get install -y build-essential \
  libanyevent-httpd-perl \
  libdata-uuid-libuuid-perl \
  libdatetime-perl \
  libdbd-sqlite3-perl \
  libdbi-perl \
  libemail-address-perl \
  libemail-mime-perl \
  libhtml-parser-perl \
  libhtml-strip-perl \
  libhttp-tiny-perl \
  libhttp-date-perl \
  libimage-size-perl \
  libio-socket-ssl-perl \
  libjson-perl \
  libjson-xs-perl \
  liblocale-gettext-perl \
  libswitch-perl \
  nginx screen curl

RUN adduser jmap

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN cpanm AnyEvent::HTTPD

RUN cd /home/jmap/ && \
    curl -L http://search.cpan.org/CPAN/authors/id/C/CI/CINDY/AnyEvent-HTTPD-SendMultiHeaderPatch-v0.1.2.tar.gz -o SendMultiHeaderPatch && \
    tar xzfv SendMultiHeaderPatch && \
    cd AnyEvent-HTTPD-SendMultiHeaderPatch-v0.1.2 && \
    perl Makefile.PL && make && make install

RUN cpanm AnyEvent::HTTPD::CookiePatch AnyEvent::IMAP Cookie::Baker Date::Parse HTML::GenerateUtil \
  AnyEvent::HTTP Email::Sender::Simple Moose IO::All Net::Server::PreFork

COPY . /home/jmap/jmap-perl

RUN cp /home/jmap/jmap-perl/nginx.conf /etc/nginx/sites-enabled/default

CMD /home/jmap/jmap-perl/bin/run.sh
