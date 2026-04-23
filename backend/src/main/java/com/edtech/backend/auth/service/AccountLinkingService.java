package com.edtech.backend.auth.service;

import java.util.List;

import com.edtech.backend.auth.dto.request.LinkProviderRequest;
import com.edtech.backend.auth.dto.request.SetPasswordRequest;
import com.edtech.backend.auth.dto.response.LinkedProviderResponse;
import com.edtech.backend.auth.enums.AuthProvider;

/**
 * Service quản lý liên kết tài khoản 2 chiều:
 * - OAuth user → thiết lập username/password
 * - Password user → link Google/Facebook
 */
public interface AccountLinkingService {

    /** Link OAuth provider vào user hiện tại (đã authenticated) */
    void linkProvider(String username, LinkProviderRequest request);

    /** OAuth user thiết lập username + password để login truyền thống */
    void setPassword(String username, SetPasswordRequest request);

    /** Gỡ liên kết provider (validate phải còn ít nhất 1 cách login) */
    void unlinkProvider(String username, AuthProvider provider);

    /** Lấy danh sách linked providers */
    List<LinkedProviderResponse> getLinkedProviders(String username);
}
