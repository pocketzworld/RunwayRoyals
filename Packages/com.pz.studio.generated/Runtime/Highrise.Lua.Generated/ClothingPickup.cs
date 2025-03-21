/*

    Copyright (c) 2025 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;
using Highrise.Studio;
using Highrise.Lua;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/ClothingPickup")]
    [LuaRegisterType(0xfffdcb3f694817ad, typeof(LuaBehaviour))]
    public class ClothingPickup : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "a4ed7dc0eee849941bdac4fac8873284";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public System.String m_testID = "shirt-n_hrideasfundedudc2024dragonkeepernightlifeshirt";

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_testID),
            };
        }
    }
}

#endif
