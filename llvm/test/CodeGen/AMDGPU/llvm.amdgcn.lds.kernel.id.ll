; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn--amdhsa -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

declare i32 @llvm.amdgcn.lds.kernel.id()
declare i32 @llvm.amdgcn.workgroup.id.x()

define void @function_lds_id(ptr addrspace(1) %out) {
; GCN-LABEL: function_lds_id:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_add_i32 s4, s15, s12
; GCN-NEXT:    v_mov_b32_e32 v2, s4
; GCN-NEXT:    flat_store_dword v[0:1], v2
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %tmp0 = call i32 @llvm.amdgcn.lds.kernel.id()
  %help = call i32 @llvm.amdgcn.workgroup.id.x()
  %both = add i32 %tmp0, %help
  store i32 %both, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @kernel_lds_id(ptr addrspace(1) %out) !llvm.amdgcn.lds.kernel.id !0 {
; GCN-LABEL: kernel_lds_id:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GCN-NEXT:    s_add_i32 s2, s6, 42
; GCN-NEXT:    v_mov_b32_e32 v2, s2
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    flat_store_dword v[0:1], v2
; GCN-NEXT:    s_endpgm
  %tmp0 = call i32 @llvm.amdgcn.lds.kernel.id()
  %help = call i32 @llvm.amdgcn.workgroup.id.x()
  %both = add i32 %tmp0, %help
  store i32 %both, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @indirect_lds_id(ptr addrspace(1) %out) !llvm.amdgcn.lds.kernel.id !1 {
; GCN-LABEL: indirect_lds_id:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s32, 0
; GCN-NEXT:    s_mov_b32 flat_scratch_lo, s7
; GCN-NEXT:    s_add_i32 s6, s6, s9
; GCN-NEXT:    s_lshr_b32 flat_scratch_hi, s6, 8
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    s_mov_b32 s3, 0x1e8f000
; GCN-NEXT:    s_mov_b64 s[0:1], flat_scratch
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, function_lds_id@gotpcrel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, function_lds_id@gotpcrel32@hi+12
; GCN-NEXT:    s_load_dwordx2 s[6:7], s[6:7], 0x0
; GCN-NEXT:    s_mov_b32 s15, 21
; GCN-NEXT:    s_mov_b32 s12, s8
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    v_mov_b32_e32 v1, s5
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    s_endpgm
  call void @function_lds_id(ptr addrspace(1) %out)
  ret void
}

define amdgpu_kernel void @doesnt_use_it(ptr addrspace(1) %out) !llvm.amdgcn.lds.kernel.id !0 {
; GCN-LABEL: doesnt_use_it:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GCN-NEXT:    v_mov_b32_e32 v2, 0x64
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    flat_store_dword v[0:1], v2
; GCN-NEXT:    s_endpgm
  store i32 100, ptr addrspace(1) %out
  ret void
}


!0 = !{i32 42}
!1 = !{i32 21}
