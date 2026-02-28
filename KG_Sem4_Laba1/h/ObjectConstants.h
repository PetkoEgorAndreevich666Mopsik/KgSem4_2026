#pragma once
#include <DirectXMath.h>

struct ObjectConstants
{
    DirectX::XMFLOAT4X4 mWorldViewProj;
    DirectX::XMFLOAT4 mUVTransform;      // xy = scale, zw = offset
    DirectX::XMFLOAT4 mBlendFactor;      // x = blend factor для интерполяции текстур

    ObjectConstants()
    {
        DirectX::XMStoreFloat4x4(&mWorldViewProj, DirectX::XMMatrixIdentity());
        mUVTransform = DirectX::XMFLOAT4(1.0f, 1.0f, 0.0f, 0.0f);
        mBlendFactor = DirectX::XMFLOAT4(0.0f, 0.0f, 0.0f, 0.0f);
    }
};