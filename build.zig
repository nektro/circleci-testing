const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable(
        b.fmt("{}-{}-{}", .{
            "circleci-testing",
            @tagName(target.os_tag orelse unreachable),
            @tagName(target.cpu_arch orelse unreachable),
        }),
        "src/main.zig",
    );
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.strip = true;
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
