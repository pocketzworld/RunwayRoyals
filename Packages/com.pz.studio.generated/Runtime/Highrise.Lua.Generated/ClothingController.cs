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
    [AddComponentMenu("Lua/ClothingController")]
    [LuaRegisterType(0x81fc5a084c0c5ab9, typeof(LuaBehaviour))]
    public class ClothingController : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "c6aaea27972dd1c438654334b2ff2a92";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.GameObject m_selectdClothesUIObject = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_selectdClothesUIObject),
            };
        }
    }
}

#endif
