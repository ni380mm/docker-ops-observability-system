# 🚀 基于 Docker Compose 的轻量级全栈可观测性平台

## 📖 项目背景
本项目旨在解决中小型项目在资源受限环境及复杂网络下的运维痛点。基于 `Docker Compose`，不仅实现了 Nginx 与 MySQL 业务服务的容器编排与自动化灾备，还深度集成了 Prometheus、Grafana、cAdvisor 与 Loki、Promtail，构建了集 **指标监控 (Metrics)** 与 **日志聚合 (Logs)** 于一体的全栈可观测性架构。

## 🛠️ 技术栈
* **容器与编排**：Docker, Docker Compose
* **业务服务**：Nginx, MySQL 8.0
* **指标监控**：Prometheus, Grafana, cAdvisor, Node Exporter
* **日志聚合**：Grafana Loki, Promtail
* **自动化运维**：Shell Script, Crontab

## 🔥 核心实战与排错记录
在实战部署中，遇到了大量真实的工程问题并成功解决：
1. **网络限制突破**：解决 `gcr.io` 镜像拉取超时问题，替换为国内镜像源；针对网络丢包，调整 Docker 的 `mtu` 值。
2. **底层兼容性排错**：在 CentOS 7 (cgroup v1) 下，解决新版 cAdvisor 丢失 `name` 标签导致 Grafana 面板全盘 `No Data` 的问题，通过重写 PromQL 聚合查询成功恢复图表。
3. **全栈可观测性打通**：配置 Promtail 实时采集宿主机所有 Docker 容器的底层日志文件，推送到 Loki 进行存储。在 Grafana 中不仅实现了 Pod 级指标监控，还能通过 LogQL 快速检索报错日志。

## ✨ 架构与调优亮点<img width="2557" height="1428" alt="cpu-monitoring png" src="https://github.com/user-attachments/assets/2fe9c352-b064-482f-99b0-d4dfa01de1c0" />

1. **极限资源硬限制**：针对低配服务器，通过 `deploy.resources.limits` 严格限制 MySQL、Grafana 等容器的内存上限，防止宿主机 OOM；调小 MySQL `innodb_buffer_pool_size`。
2. **健康检查与依赖控制**：配置 `healthcheck` 与 `depends_on`，确保 MySQL 完全就绪后 Nginx 才启动，解决启动死锁。
3. **自动化灾备机制**：编写 Shell 脚本配合 Crontab，每日凌晨全量备份 MySQL 数据，使用 `gzip` 压缩，并通过 `find` 自动清理 7 天前历史备份。

## 📸 效果展示


![Loki 日志大盘](效果展示/你的日志截图名字.png)
![Grafana 容器监控](效果展示/你的CPU截图名字.png)
