#!/usr/bin/env bash
sudo systemctl stop libvirtd.service
sudo systemctl stop libvirtd.socket
sudo systemctl stop virtlogd.service
sudo systemctl stop virtlogd.socket
