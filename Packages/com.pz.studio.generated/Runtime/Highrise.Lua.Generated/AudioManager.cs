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
    [AddComponentMenu("Lua/AudioManager")]
    [LuaRegisterType(0x54ef1694c40a5ef8, typeof(LuaBehaviour))]
    public class AudioManager : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "776f55b6d2c2627498787481d0546290";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public Highrise.AudioShader m_BGMusic = default;
        [SerializeField] public System.String m_idleMusicURL = "https://streamssl.chilltrax.com:80/";
        [SerializeField] public Highrise.AudioShader m_EmojiParticle = default;
        [SerializeField] public Highrise.AudioShader m_EmojiButton = default;
        [SerializeField] public Highrise.AudioShader m_CameraFlashFinal = default;
        [SerializeField] public Highrise.AudioShader m_VictoryParticlesSounds = default;
        [SerializeField] public Highrise.AudioShader m_CameraFlashSmall = default;
        [SerializeField] public Highrise.AudioShader m_TeleportSound = default;
        [SerializeField] public Highrise.AudioShader m_AlertSound = default;
        [SerializeField] public Highrise.AudioShader m_TickSound = default;
        [SerializeField] public Highrise.AudioShader m_ShowtimeSound = default;
        [SerializeField] public Highrise.AudioShader m_HitReadySound = default;
        [SerializeField] public Highrise.AudioShader m_StartingSound = default;
        [SerializeField] public Highrise.AudioShader m_DressUpSound = default;
        [SerializeField] public Highrise.AudioShader m_NextModelSound = default;
        [SerializeField] public Highrise.AudioShader m_CashSound = default;
        [SerializeField] public Highrise.AudioShader m_clothSound = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_BGMusic),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_idleMusicURL),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_EmojiParticle),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_EmojiButton),
                CreateSerializedProperty(_script.GetPropertyAt(4), m_CameraFlashFinal),
                CreateSerializedProperty(_script.GetPropertyAt(5), m_VictoryParticlesSounds),
                CreateSerializedProperty(_script.GetPropertyAt(6), m_CameraFlashSmall),
                CreateSerializedProperty(_script.GetPropertyAt(7), m_TeleportSound),
                CreateSerializedProperty(_script.GetPropertyAt(8), m_AlertSound),
                CreateSerializedProperty(_script.GetPropertyAt(9), m_TickSound),
                CreateSerializedProperty(_script.GetPropertyAt(10), m_ShowtimeSound),
                CreateSerializedProperty(_script.GetPropertyAt(11), m_HitReadySound),
                CreateSerializedProperty(_script.GetPropertyAt(12), m_StartingSound),
                CreateSerializedProperty(_script.GetPropertyAt(13), m_DressUpSound),
                CreateSerializedProperty(_script.GetPropertyAt(14), m_NextModelSound),
                CreateSerializedProperty(_script.GetPropertyAt(15), m_CashSound),
                CreateSerializedProperty(_script.GetPropertyAt(16), m_clothSound),
            };
        }
    }
}

#endif
