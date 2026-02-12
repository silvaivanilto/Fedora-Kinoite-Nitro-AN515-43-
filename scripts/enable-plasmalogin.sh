#!/bin/bash

# Ensure sddm service is disabled
systemctl disable --force sddm.service

# Force enable plasmalogin service as requested
systemctl enable --force plasmalogin.service
