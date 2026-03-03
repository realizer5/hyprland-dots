#!/usr/bin/env bash
sudo systemctl start libvirtd.service
sudo systemctl start libvirtd.socket
sudo systemctl start virtlogd.service
sudo systemctl start virtlogd.socket
