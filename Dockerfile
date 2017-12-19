FROM resin/rpi-raspbian:stretch
RUN adduser --system --home=/opt/odoo --group odoo
RUN apt-get update \
	&& apt-get install -y --no-install-recommends git 
USER odoo
RUN cd /opt/odoo \
    && git clone https://github.com/odoo/odoo.git --depth 1 --branch 11.0 --single-branch .

USER root
RUN apt-get update \
	&& apt-get install -y build-essential python3 python3-pip python3-wheel ca-certificates node-less python3-setuptools python3-renderpm libssl1.0-dev xz-utils libpq-dev zlibc libxml2-dev python3-dev libxslt1-dev libjpeg-dev zlib1g-dev libsasl2-dev libldap2-dev python3-lxml wkhtmltopdf

RUN pip3 install -r /opt/odoo/requirements.txt 
ENV ODOO_VERSION 11.0
ENV ODOO_RELEASE 20171030

COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
RUN chown odoo /etc/odoo/odoo.conf

RUN ln -s /opt/odoo/odoo-bin /usr/bin/odoo

RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

EXPOSE 8069 8071
ENV ODOO_RC /etc/odoo/odoo.conf
USER odoo
ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
