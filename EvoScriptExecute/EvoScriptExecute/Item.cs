﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EvoScriptExecute
{
    class Item
    {

        string path;
        string step;
        string necesary;
        string daddy;
        string scriptName;
        public string Path
        {
            get
            {
                return path;
            }

            set
            {
                path = value;
            }
        }

        public string Step
        {
            get
            {
                return step;
            }

            set
            {
                step = value;
            }
        }

        public string Necesary
        {
            get
            {
                return necesary;
            }

            set
            {
                necesary = value;
            }
        }

        public string Daddy
        {
            get
            {
                return daddy;
            }

            set
            {
                daddy = value;
            }
        }

        public string ScriptName
        {
            get
            {
                return scriptName;
            }

            set
            {
                scriptName = value;
            }
        }
    }
}
