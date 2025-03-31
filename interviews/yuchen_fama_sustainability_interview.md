# Interview with Yuchen Fama  
**VP of Product, Exostellar | 15+ years of AI/ML R&D**  
[LinkedIn](https://www.linkedin.com/in/yuchen-fama-b673a420/)

---

### Question 1: With the rapid advancements in AI, there is a growing challenge of balancing increased computational demands with sustainability. How do you propose mitigating AI’s environmental impact in a way that also helps reduce infrastructure costs?

**Answer:**  
From a top-down view of the stack, the first consideration is model layer optimization, with many advancements in the last few years, such as sparsity, distillation, and, more recently, MoE/MLA from DeepSeek. In my opinion, the future of enterprise AI lies in small-but-mighty models collaborating in agentic workflows with continuous learning. Most companies don’t need to hire the smartest person in the world; instead, they need many specialists collaborating, learning, adapting, and bouncing ideas off each other.

Next is the infrastructure resource orchestration and optimization layer. Almost every organization is GPU-starving, yet the average utilization is 20–30%, especially in enterprises with many AI teams and diverse workloads—such as interactive development (where 70% of R&D time leads to idled GPU resources), fine-tuning/training, inference, and heterogeneous patterns (batch, real-time, burstable, etc.).

Improving resource efficiency by modernizing the whole orchestration—requesting, allocation, scheduling, and monitoring—needs to be a top priority for every AI leader, as it not only improves ROI by reducing waste and costs, but also accelerates time-to-market by rapid experimentation and iteration.

---

### Question 2: Have you observed any significant impacts of adopting sustainability practices in your work?

**Answer:**  
The math from the resource utilization side of the equation can be directly translated into energy savings. For example, we recently proved a 73% memory reduction (approximately 4.7x memory utilization) while maintaining the same accuracy. This translates to a reduction from 100 GPUs to 27 GPUs, which—factoring in power and cooling—yields an energy savings of more than 80%. When CO₂ reduction, water, and other facility energy footprints are considered, the environmental benefit is as significant as, if not more so than, the economic impact.

---

### Question 3: As a leader, what would you suggest to AI practitioners and organizations on how they can reduce their carbon emissions?

**Answer:**  
On the model and infrastructure layer mentioned above, I’ve seen more benchmarks using performance-per-watt alongside accuracy metrics, which is a good trend. I’m also a big advocate of continuous learning and gave a talk at GTC 2022—massive head-to-toe training oftentimes is overkill and struggles to adapt to changing environments with more data/model drift.

On the hardware layer down to transistors, we have a long way to go with a lot of room to innovate, like the arithmetic logical unit. Our human brain only needs 14 watts and we constantly learn and update our knowledge. ChatGPT training costs more energy than a human uses in a lifetime*. True AGI needs to be physics-inspired and nature-inspired, and the criteria of AGI should also be measured by energy consumed per unit of information processed.

I only have less than one year of experience in memory chips, so my opinion is quite limited—but I think joint software + hardware optimization to close the loop is the key. We are living in an exciting time and I cannot wait to see the next AGI breakthrough!

> *Original and uncurated opinion, with only grammar help from ChatGPT*  
> — **Yuchen Fama**

> \* Shankar, IEEE, 2023
