#!/usr/bin/env python
import os

def get_env_variable(env_variable_name: str):
    return os.getenv(env_variable_name, default='')